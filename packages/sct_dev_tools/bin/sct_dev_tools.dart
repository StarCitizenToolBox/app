import 'auto_l10n.dart';

void main(List<String> args) {
  switch (args.elementAtOrNull(0)) {
    case "gen":
      return AutoL10nTools().genL10nFiles();
    case "replace":
      return AutoL10nTools().replaceL10nFiles();
    default:
      throw Exception("cmd not found");
  }
}
