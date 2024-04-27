use notify_rust::Notification;

pub fn send_notify(summary: Option<String>, body: Option<String>, app_name: Option<String>, app_id: Option<String>) -> anyhow::Result<()> {
    let mut n = Notification::new();
    if let Some(summary) = summary {
        n.summary(&summary);
    }
    if let Some(body) = body {
        n.body(&body);
    }
    if let Some(app_name) = app_name {
        n.appname(&app_name);
    }
    if let Some(app_id) = app_id {
        n.app_id(&app_id);
    }
    n.show()?;
    Ok(())
}