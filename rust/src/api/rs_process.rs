use std::collections::HashMap;
use std::sync::Arc;

use async_std::task::block_on;
use once_cell::sync::Lazy;
use scopeguard::defer;
use tokio::io::AsyncBufReadExt;
use tokio::io::AsyncWriteExt;
use tokio::io::BufReader;
use tokio::process::ChildStdin;
use tokio::sync::Mutex;

use crate::frb_generated::StreamSink;

#[derive(Clone, Copy)]
pub enum RsProcessStreamDataType {
    Output,
    Error,
    Exit,
}

pub struct RsProcessStreamData {
    pub data_type: RsProcessStreamDataType,
    pub data: String,
    pub rs_pid: u32,
}

pub struct RsProcess {
    pub child_stdin: ChildStdin,
    pub rs_pid: u32,
}

static RS_PROCESS_MAP: Lazy<Mutex<HashMap<u32, RsProcess>>> = Lazy::new(|| Mutex::new(HashMap::new()));

pub async fn start(
    executable: &str,
    arguments: Vec<String>,
    working_directory: &str,
    stream_sink: StreamSink<RsProcessStreamData>,
) {
    let stream_sink_arc = Arc::from(stream_sink);
    let mut command = tokio::process::Command::new(executable);
    command
        .args(arguments)
        .current_dir(working_directory)
        .stdin(std::process::Stdio::piped())
        .stdout(std::process::Stdio::piped())
        .stderr(std::process::Stdio::piped())
        .kill_on_drop(true);

    command.creation_flags(0x08000000);

    let job = win32job::Job::create().unwrap();
    let mut info = job.query_extended_limit_info().unwrap();
    info.limit_kill_on_job_close();
    job.set_extended_limit_info(&mut info).unwrap();

    let job_arc = Arc::from(job);

    if let Ok(mut child) = command.spawn() {
        {
            let raw_handle = child.raw_handle();
            if raw_handle.is_some() {
                job_arc
                    .assign_process(raw_handle.unwrap() as isize)
                    .unwrap();
            }
        }

        let stdin = child
            .stdin
            .take()
            .expect("[rs_process] Failed to open stdin");
        let pid = child.id().expect("[rs_process] Failed to get pid");
        {
            let mut map = RS_PROCESS_MAP.lock().await;
            map.insert(
                pid,
                RsProcess {
                    child_stdin: stdin,
                    rs_pid: pid,
                },
            );
        }

        defer! {
            let mut map = block_on(RS_PROCESS_MAP.lock());
            map.remove(&pid);
            println!("RS_PROCESS_MAP ..defer ..len() = {}", map.len());
        }

        let stdout = child
            .stdout
            .take()
            .expect("[rs_process] Failed to open stdout");
        let stderr = child
            .stderr
            .take()
            .expect("[rs_process] Failed to open stderr");

        let output_task = tokio::spawn(_process_output(
            stdout,
            stream_sink_arc.clone(),
            RsProcessStreamDataType::Output,
            pid,
        ));
        let error_task = tokio::spawn(_process_output(
            stderr,
            stream_sink_arc.clone(),
            RsProcessStreamDataType::Error,
            pid,
        ));

        tokio::select! {_ = output_task => (), _ = error_task => () }

        let exit_status = child
            .wait()
            .await
            .expect("[rs_process] Failed to wait for child process");

        if !exit_status.success() {
            println!(
                "[rs_process] Child process exited with an error: {:?}",
                exit_status
            );
            let message = RsProcessStreamData {
                data_type: RsProcessStreamDataType::Exit,
                data: "exit".to_string(),
                rs_pid: pid,
            };
            stream_sink_arc.add(message).unwrap();
        }
    } else {
        println!("Failed to start");
        let message = RsProcessStreamData {
            data_type: RsProcessStreamDataType::Error,
            data: "Failed to start".to_string(),
            rs_pid: 0,
        };
        stream_sink_arc.add(message).unwrap();
    }
}

pub async fn write(rs_pid: &u32, data: String) {
    let mut map = RS_PROCESS_MAP.lock().await;
    let process = map.get_mut(rs_pid).unwrap();
    process
        .child_stdin
        .write_all(data.as_bytes())
        .await
        .unwrap();
}

async fn _process_output<R>(
    stdout: R,
    stream_sink: Arc<StreamSink<RsProcessStreamData>>,
    data_type: RsProcessStreamDataType,
    pid: u32,
) where
    R: tokio::io::AsyncRead + Unpin,
{
    let reader = BufReader::new(stdout);
    let mut lines = reader.lines();

    while let Some(line) = lines.next_line().await.unwrap() {
        let message = RsProcessStreamData {
            data_type,
            data: line.trim().parse().unwrap(),
            rs_pid: pid,
        };
        stream_sink.add(message).unwrap();
    }
}
