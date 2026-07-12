use std::io;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum MirrorUnavailableReason {
    NotEligible,
    NotMirrored,
    IncompleteBase,
    ReleaseMismatch,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct MirrorUnavailable {
    pub reason: MirrorUnavailableReason,
    pub object_sha256: Option<String>,
    pub compressed_size: Option<u64>,
    pub message: String,
}

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
    #[error("mirror unavailable: {0:?}")]
    MirrorUnavailable(MirrorUnavailable),
}

pub type Result<T> = std::result::Result<T, Error>;

pub(crate) fn fail<T>(message: impl Into<String>) -> Result<T> {
    Err(Error::Message(message.into()))
}

pub(crate) fn unavailable<T>() -> Result<T> {
    fail(UNAVAILABLE_MESSAGE)
}
