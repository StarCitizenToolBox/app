import 'auto_l10n.dart';

void main(List<String> args) async {
  switch (args.elementAtOrNull(0)) {
    case "l10n_gen":
      return AutoL10nTools().genL10nFiles();
    case "l10n_replace":
      return AutoL10nTools().replaceL10nFiles();
    case "l10n_auto_translate":
      final form = args.elementAtOrNull(1);
      final to = args.elementAtOrNull(2);
      if (form == null || to == null) {
        throw Exception("form or to is null");
      }
      return await AutoL10nTools().autoTranslate(form: form, to: to);
    default:
      throw Exception("cmd not found");
  }
}
