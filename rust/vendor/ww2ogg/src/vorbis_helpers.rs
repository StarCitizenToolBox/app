//! Helper functions from the Vorbis specification.

/// Integer log base 2 - returns the number of bits needed to represent a value.
///
/// Named to match the Vorbis specification.
/// Returns 0 for input 0, otherwise returns floor(log2(v)) + 1.
#[inline]
pub fn ilog(v: u32) -> u8 {
    if v == 0 {
        0
    } else {
        32 - v.leading_zeros() as u8
    }
}

/// Calculate the number of quantized values for a type 1 lookup table.
///
/// This is used in codebook decoding to determine how many values
/// to read for a multiplicative lookup table.
pub fn book_map_type1_quantvals(entries: u32, dimensions: u32) -> u32 {
    if dimensions == 0 {
        return 0;
    }

    let bits = ilog(entries);
    let mut vals = entries >> ((bits as u32 - 1) * (dimensions - 1) / dimensions);

    loop {
        let mut acc: u64 = 1;
        let mut acc1: u64 = 1;

        for _ in 0..dimensions {
            acc = acc.saturating_mul(vals as u64);
            acc1 = acc1.saturating_mul((vals + 1) as u64);
        }

        if acc <= entries as u64 && acc1 > entries as u64 {
            return vals;
        }

        if acc > entries as u64 {
            vals -= 1;
        } else {
            vals += 1;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_ilog() {
        assert_eq!(ilog(0), 0);
        assert_eq!(ilog(1), 1);
        assert_eq!(ilog(2), 2);
        assert_eq!(ilog(3), 2);
        assert_eq!(ilog(4), 3);
        assert_eq!(ilog(7), 3);
        assert_eq!(ilog(8), 4);
        assert_eq!(ilog(255), 8);
        assert_eq!(ilog(256), 9);
    }

    #[test]
    fn test_book_map_type1_quantvals() {
        // Common cases from Vorbis codebooks
        // We want the largest vals such that vals^dimensions <= entries and (vals+1)^dimensions > entries
        assert_eq!(book_map_type1_quantvals(8, 2), 2); // 2^2 = 4 <= 8, 3^2 = 9 > 8
        assert_eq!(book_map_type1_quantvals(27, 3), 3); // 3^3 = 27
        assert_eq!(book_map_type1_quantvals(16, 2), 4); // 4^2 = 16
        assert_eq!(book_map_type1_quantvals(9, 2), 3); // 3^2 = 9 <= 9, 4^2 = 16 > 9
        assert_eq!(book_map_type1_quantvals(1, 1), 1); // 1^1 = 1
    }
}
