import 'package:flutter/widgets.dart' show StringCharacters;

class InputMethodEncodeResult {
  /// `[zh] ...` text ready for the game chat, or "" when nothing is encodable.
  final String text;

  /// Characters that are neither ASCII nor in the input method table (written as spaces).
  final List<String> unsupported;

  const InputMethodEncodeResult(this.text, this.unsupported);
}

final _asciiSafe = RegExp(r'^[a-zA-Z0-9\p{P}\p{S}]+$', unicode: true);
final _ascii = RegExp(r'^[\x00-\x7F]+$');

/// Encodes [src] with the community input method table ([charToCode]: character -> ini key).
/// Table characters become `@code`, ASCII letters / digits / symbols stay as they are.
InputMethodEncodeResult encodeCommunityInputMethod(String src, Map<String, String> charToCode) {
  final sb = StringBuffer();
  final unsupported = <String>[];
  var leftSafe = true;
  for (final c in src.characters) {
    // Full-width punctuation such as ，。 has codes in the table, so look it up before
    // treating it as a plain symbol.
    final isAscii = _ascii.hasMatch(c);
    final code = isAscii ? null : charToCode[c.trim()];
    if (code == null && isAscii && _asciiSafe.hasMatch(c)) {
      sb.write(leftSafe ? c : " $c");
      leftSafe = true;
      continue;
    }
    if (code != null) {
      if (leftSafe) sb.write(" ");
      sb.write("@$code");
    } else {
      // 不支持转码，用空格代替
      sb.write(" ");
      if (c.trim().isNotEmpty && !unsupported.contains(c)) unsupported.add(c);
    }
    leftSafe = false;
  }
  if (sb.toString().trim().isEmpty) return InputMethodEncodeResult("", unsupported);
  return InputMethodEncodeResult("[zh] ${sb.toString()}", unsupported);
}
