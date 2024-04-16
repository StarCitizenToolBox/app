use flutter_rust_bridge::for_generated::futures::lock::Mutex;
use std::sync::Arc;

use flutter_rust_bridge::frb;
use tokio::io::BufReader;
use tokio::io::{AsyncBufReadExt, AsyncWriteExt};
use tokio::process::ChildStdin;

use crate::frb_generated::StreamSink;

#[frb(opaque)]
pub struct RsProcess {
    child_stdin: Option<Arc<Mutex<ChildStdin>>>,
    pid: Option<u32>,
}

#[derive(Clone, Copy)]
pub enum RsProcessStreamDataType {
    Output,
    Error,
    Exit,
}

pub struct RsProcessStreamData {
    pub data_type: RsProcessStreamDataType,
    pub data: String,
}

impl RsProcess {
    #[frb(sync)]
    pub fn new() -> Self {
        RsProcess {
            child_stdin: None,
            pid: None,
        }
    }

    pub async fn start(
        &mut self,
        executable: String,
        arguments: Vec<String>,
        working_directory: String,
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

            let stdout = child.stdout.take().expect("Failed to open stdout");
            let stderr = child.stderr.take().expect("Failed to open stderr");

            let stdin = child.stdin.take().expect("Failed to open stdin");
            self.child_stdin = Some(Arc::from(Mutex::new(stdin)));
            
            let output_task = tokio::spawn(_process_output(
                stdout,
                stream_sink_arc.clone(),
                RsProcessStreamDataType::Output,
            ));
            let error_task = tokio::spawn(_process_output(
                stderr,
                stream_sink_arc.clone(),
                RsProcessStreamDataType::Error,
            ));

            self.pid = child.id();

            tokio::select! {
            _ = output_task => (),
            _ = error_task => (),
            }

            let exit_status = child
                .wait()
                .await
                .expect("Failed to wait for child process");

            if !exit_status.success() {
                eprintln!("Child process exited with an error: {:?}", exit_status);
                let message = RsProcessStreamData {
                    data_type: RsProcessStreamDataType::Exit,
                    data: "exit".to_string(),
                };
                stream_sink_arc.add(message).unwrap();
            }
        } else {
            eprintln!("Failed to start");
            let message = RsProcessStreamData {
                data_type: RsProcessStreamDataType::Error,
                data: "Failed to start".to_string(),
            };
            stream_sink_arc.add(message).unwrap();
        }
    }

    pub async fn write(&mut self, data: String) {
        if let Some(stdin) = &self.child_stdin {
            let mut stdin_lock = stdin.lock().await;
            stdin_lock.write_all(data.as_bytes()).await.unwrap();
        }
    }

    #[frb(sync)]
    pub fn get_pid(&self) -> Option<u32> {
        self.pid
    }
}

async fn _process_output<R>(
    stdout: R,
    stream_sink: Arc<StreamSink<RsProcessStreamData>>,
    data_type: RsProcessStreamDataType,
) where
    R: tokio::io::AsyncRead + Unpin,
{
    let reader = BufReader::new(stdout);
    let mut lines = reader.lines();

    while let Some(line) = lines.next_line().await.unwrap() {
        let message = RsProcessStreamData {
            data_type,
            data: line.trim().parse().unwrap(),
        };
        stream_sink.add(message).unwrap();
    }
}
