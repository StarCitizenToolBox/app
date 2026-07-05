use std::io;

pub const UNAVAILABLE_MESSAGE: &str =
    "P4K upgrader is unavailable in the community build; closed-source module is not installed";

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("{0}")]
    Message(String),
    #[error("io error: {0}")]
    Io(#[from] io::Error),
    #[error("json error: {0}")]
    Json(#[from] serde_json::Error),
    #[error("http error: {0}")]
    Http(#[from] reqwest::Error),
    #[error("regex error: {0}")]
    Regex(#[from] regex::Error),
    #[error("invalid hex: {0}")]
    Hex(String),
}

pub type Result<T> = std::result::Result<T, Error>;

pub(crate) fn fail<T>(message: impl Into<String>) -> Result<T> {
    Err(Error::Message(message.into()))
}

pub(crate) fn unavailable<T>() -> Result<T> {
    fail(UNAVAILABLE_MESSAGE)
}
