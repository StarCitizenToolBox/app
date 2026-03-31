//! Error types for ww2ogg conversion.

use thiserror::Error;

/// Result type alias for ww2ogg operations.
pub type WemResult<T> = Result<T, WemError>;

/// Errors that can occur during Wwise audio conversion.
#[derive(Debug, Error)]
pub enum WemError {
    /// A required file could not be opened or found.
    #[error("Error opening {filename}")]
    FileOpen {
        /// The name of the file that could not be opened.
        filename: String,
    },

    /// The input file contains invalid or malformed data.
    #[error("Parse error: {message}")]
    Parse {
        /// Description of the parse error.
        message: String,
    },

    /// The codebook data size doesn't match the expected size.
    /// This typically indicates the wrong codebook library is being used.
    #[error("Parse error: expected {expected} bytes, read {actual} - likely wrong codebook")]
    SizeMismatch {
        /// The expected size in bytes.
        expected: u64,
        /// The actual size that was read.
        actual: u64,
    },

    /// A codebook ID referenced in the audio file is not found in the codebook library.
    #[error("Parse error: invalid codebook id {id}, try --inline-codebooks")]
    InvalidCodebookId {
        /// The invalid codebook ID that was not found.
        id: i32,
    },

    /// General codebook-related error.
    /// This typically indicates the wrong codebook library is being used.
    #[error("{message}")]
    Codebook {
        /// Description of the codebook error.
        message: String,
    },

    /// An I/O error occurred.
    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),

    /// Unexpected end of stream.
    #[error("Unexpected end of stream: {message}")]
    EndOfStream {
        /// Description of where the end of stream occurred.
        message: String,
    },
}

impl WemError {
    /// Create a new parse error with the given message.
    pub fn parse(message: impl Into<String>) -> Self {
        WemError::Parse {
            message: message.into(),
        }
    }

    /// Create a new codebook error with the given message.
    pub fn codebook(message: impl Into<String>) -> Self {
        WemError::Codebook {
            message: message.into(),
        }
    }

    /// Create a new file open error.
    pub fn file_open(filename: impl Into<String>) -> Self {
        WemError::FileOpen {
            filename: filename.into(),
        }
    }

    /// Create a new size mismatch error.
    pub fn size_mismatch(expected: u64, actual: u64) -> Self {
        WemError::SizeMismatch { expected, actual }
    }

    /// Create a new invalid codebook ID error.
    pub fn invalid_codebook_id(id: i32) -> Self {
        WemError::InvalidCodebookId { id }
    }

    /// Create a new end of stream error.
    pub fn end_of_stream(message: impl Into<String>) -> Self {
        WemError::EndOfStream {
            message: message.into(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_error() {
        let err = WemError::parse("test message");
        assert!(matches!(err, WemError::Parse { .. }));
        assert!(err.to_string().contains("test message"));
    }

    #[test]
    fn test_codebook_error() {
        let err = WemError::codebook("codebook issue");
        assert!(matches!(err, WemError::Codebook { .. }));
        assert!(err.to_string().contains("codebook issue"));
    }

    #[test]
    fn test_file_open_error() {
        let err = WemError::file_open("test.wem");
        assert!(matches!(err, WemError::FileOpen { .. }));
        assert!(err.to_string().contains("test.wem"));
    }

    #[test]
    fn test_size_mismatch_error() {
        let err = WemError::size_mismatch(100, 50);
        assert!(matches!(err, WemError::SizeMismatch { .. }));
        let msg = err.to_string();
        assert!(msg.contains("100"));
        assert!(msg.contains("50"));
    }

    #[test]
    fn test_invalid_codebook_id_error() {
        let err = WemError::invalid_codebook_id(42);
        assert!(matches!(err, WemError::InvalidCodebookId { .. }));
        assert!(err.to_string().contains("42"));
    }

    #[test]
    fn test_end_of_stream_error() {
        let err = WemError::end_of_stream("reading header");
        assert!(matches!(err, WemError::EndOfStream { .. }));
        assert!(err.to_string().contains("reading header"));
    }

    #[test]
    fn test_io_error_from() {
        let io_err = std::io::Error::new(std::io::ErrorKind::NotFound, "file not found");
        let wem_err: WemError = io_err.into();
        assert!(matches!(wem_err, WemError::Io(_)));
    }

    #[test]
    fn test_error_display() {
        // Verify all error types implement Display correctly
        let errors: Vec<WemError> = vec![
            WemError::parse("parse"),
            WemError::codebook("codebook"),
            WemError::file_open("file"),
            WemError::size_mismatch(1, 2),
            WemError::invalid_codebook_id(1),
            WemError::end_of_stream("eos"),
        ];

        for err in errors {
            // Should not panic
            let _ = err.to_string();
        }
    }
}
