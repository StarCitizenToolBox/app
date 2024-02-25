use std::sync::Arc;
use tokio::io::{AsyncBufReadExt, BufReader};
use crate::frb_generated::StreamSink;


pub async fn start_process(
    executable: String,
    arguments: Vec<String>,
    working_directory: String,
    stream_sink: StreamSink<String>,
) {
    let stream_sink_arc = Arc::from(stream_sink);

    let mut command = tokio::process::Command::new(&executable);
    command
        .args(arguments)
        .current_dir(working_directory)
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
                job_arc.assign_process(raw_handle.unwrap() as isize).unwrap();
            }
        }
        let stdout = child.stdout.take().expect("Failed to open stdout");
        let stderr = child.stderr.take().expect("Failed to open stderr");
        let output_task = tokio::spawn(process_output(stdout, stream_sink_arc.clone()));
        let error_task = tokio::spawn(process_error(stderr, stream_sink_arc.clone()));

        tokio::select! {
            _ = output_task => (),
            _ = error_task => (),
        }

        let exit_status = child.wait().await.expect("Failed to wait for child process");
        if !exit_status.success() {
            eprintln!("Child process exited with an error: {:?}", exit_status);
            stream_sink_arc.add("exit:".to_string()).unwrap();
        }
    } else {
        eprintln!("Failed to start {}", executable);
        stream_sink_arc.add("error:Failed to start".to_string()).unwrap();
    }
}

async fn process_output<R>(stdout: R, stream_sink: Arc<StreamSink<String>>)
    where
        R: tokio::io::AsyncRead + Unpin,
{
    let reader = BufReader::new(stdout);
    let mut lines = reader.lines();

    while let Some(line) = lines.next_line().await.unwrap() {
        if line.trim().is_empty() {
            continue;
        }
        println!("{}", line.trim());
        stream_sink.add("output:".to_string() + &*line.trim().to_string()).unwrap();
    }
}

async fn process_error<R>(stderr: R, stream_sink: Arc<StreamSink<String>>)
    where
        R: tokio::io::AsyncRead + Unpin,
{
    let reader = BufReader::new(stderr);
    let mut lines = reader.lines();
    while let Some(line) = lines.next_line().await.unwrap() {
        println!("{}", line.trim());
        stream_sink.add("error:".to_string() + &*line.trim().to_string()).unwrap();
    }
}

