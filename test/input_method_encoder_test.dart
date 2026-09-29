import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/ui/home/input_method/input_method_encoder.dart';
import 'package:starcitizen_doctor/ui/home/localization/localization_ui_model.dart';

void main() {
  const table = {"你": "IH", "好": "E8", "，": "1P8", "。": "1P9"};

  String encode(String s) => encodeCommunityInputMethod(s, table).text;

  test('encodes table characters as codes', () {
    expect(encode("你好"), "[zh]  @IH@E8");
  });

  test('keeps ASCII and separates it from codes', () {
    expect(encode("hi你好"), "[zh] hi @IH@E8");
    expect(encode("你好hi"), "[zh]  @IH@E8 hi");
    expect(encode("你好!"), "[zh]  @IH@E8 !");
  });

  test('uses table codes for full-width punctuation', () {
    expect(encode("你好，好。"), "[zh]  @IH@E8@1P8@E8@1P9");
  });

  test('replaces and reports unsupported characters', () {
    final r = encodeCommunityInputMethod("你😀好·😀", table);
    expect(r.text, "[zh]  @IH @E8  ");
    expect(r.unsupported, ["😀", "·"]);
  });

  test('returns empty text when nothing is encodable', () {
    expect(encode("   "), "");
    expect(encode(""), "");
  });

  test('parses the table appended to global.ini', () {
    const ini = "a=b\n"
        "_starcitizen_doctor_localization_community_input_method_version=0.0.1\n"
        "IH=你\n"
        "1P8=，\n"
        "_starcitizen_doctor_localization_version=1.0\n"
        "c=d\n";
    expect(LocalizationUIModel.parseCommunityInputMethodSupportData(ini), {"IH": "你", "1P8": "，"});
    expect(LocalizationUIModel.parseCommunityInputMethodSupportData("a=b\n"), isNull);
  });
}
