import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:translator/translator.dart';
import 'package:uuid/v4.dart';

final stringResult = <String>[];

class AutoL10nTools {
  final skipPaths = ["lib/generated"];

  void genL10nFiles() {
    final dir = Directory('lib/');
    for (var entity in dir.listSync(recursive: true)) {
      bool shouldSkip = false;
      for (var path in skipPaths) {
        if (entity.path.replaceAll("\\", "/").startsWith(path)) {
          shouldSkip = true;
        }
        break;
      }
      if (shouldSkip) continue;
      if (entity is File && entity.path.endsWith('.dart')) {
        print('Processing ${entity.path}...');
        _processDartFile(entity);
      }
    }
    if (stringResult.isNotEmpty) {
      final outputMap = <String, String>{};
      for (var value in stringResult) {
        if (outputMap.containsValue(value)) {
          continue;
        }
        var key = UuidV4().generate();
        final l10nFile = File("./lib/l10n/intl_zh_CN.arb");
        final cnJsonMap = json.decode(l10nFile.readAsStringSync()) as Map;
        for (var element in cnJsonMap.entries) {
          if (element.value == value) {
            key = element.key;
          }
        }
        outputMap[key] = value;
      }
      // output to json
      final j = json.encode(outputMap);
      File("./lib/generated/l10n_temp.json").writeAsStringSync(j);
      print(
          "output to json file (length: ${outputMap.length}): ./lib/generated/l10n_temp.json");
    }
  }

  void replaceL10nFiles() {
    final l10nFile = File("./lib/l10n/intl_zh_CN.arb");
    // readToJsonMap
    final jsonMap = json.decode(l10nFile.readAsStringSync());
    // read all dart File
    final dir = Directory('lib/');
    for (var entity in dir.listSync(recursive: true)) {
      bool shouldSkip = false;
      for (var path in skipPaths) {
        if (entity.path.replaceAll("\\", "/").startsWith(path)) {
          shouldSkip = true;
        }
        break;
      }
      if (shouldSkip) continue;
      if (entity is File &&
          entity.path.endsWith('.dart') &&
          !(entity.path.endsWith(".g.dart") &&
              !entity.path.endsWith(".freezed.dart"))) {
        print('Processing ${entity.path}...');
        // sort map with value length
        final newMap = Map<String, dynamic>.fromEntries(
          jsonMap.entries.toList()
            ..sort((a, b) => (b.value.toString())
                .length
                .compareTo((a.value.toString()).length)),
        );
        _replaceDartFile(entity, newMap);
      }
    }
  }

  Future<void> autoTranslate({required String form, required String to}) async {
    final formFile = File("./lib/l10n/intl_$form.arb");
    final toFile = File("./lib/l10n/intl_$to.arb");
    final translator = GoogleTranslator();
    final formMap =
        json.decode(formFile.readAsStringSync()) as Map<String, dynamic>;
    final toMap =
        json.decode(toFile.readAsStringSync()) as Map<String, dynamic>;

    final formLocaleCode = formMap["@@auto_translate_locale"].toString();
    final toLocaleCode = toMap["@@auto_translate_locale"].toString();
    print("formLocaleCode: $formLocaleCode, toLocaleCode: $toLocaleCode");

    final newMap = <String, dynamic>{};

    try {
      for (var key in formMap.keys) {
        if (toMap.keys.contains(key)) {
          newMap[key] = toMap[key];
          continue;
        }
        if (key.toString().startsWith("@") || key == "locale_code") {
          continue;
        }
        final value = formMap[key] as String;
        final result = await translator.translate(value,
            from: formLocaleCode, to: toLocaleCode);
        var resultValue = result.text;
        // 如果目标语言是英文，则首字母大写
        if (toLocaleCode == "en") {
          resultValue = resultValue[0].toUpperCase() + resultValue.substring(1);
        }
        print("translate $key: $value -> $resultValue");
        newMap[key] = resultValue;
        await Future.delayed(Duration(milliseconds: 500));
      }
    } catch (e) {
      print(e);
      toMap.addAll(newMap);
      toFile.writeAsStringSync(json.encode(toMap));
    }
    toMap.addAll(newMap);
    toFile.writeAsStringSync(json.encode(toMap));
  }

  void _processDartFile(File file) {
    final parseResult = parseFile(
        path: file.path, featureSet: FeatureSet.latestLanguageVersion());
    final unit = parseResult.unit;
    unit.accept(MyAstVisitor());
  }

  void _replaceDartFile(File entity, jsonMap) {
    for (var key in jsonMap.keys) {
      if (key == "@@locale") continue;
      final mapValue = jsonMap[key].toString();
      if (mapValue.contains("{") && mapValue.contains("}")) {
        // print("skipping args value === $mapValue");
        continue;
      }
      // 使用 CheckContainsVisitor.visitStringLiteral 获取是否有匹配的值 ,返回 true false
      final parseResult = parseFile(
          path: entity.path, featureSet: FeatureSet.latestLanguageVersion());
      final unit = parseResult.unit;
      final visitor = CheckContainsVisitor(mapValue);
      unit.accept(visitor);
      if (visitor.hasValue) {
        // replaceDartFile with line
        final lines = entity.readAsLinesSync();
        final newLines = <String>[];
        for (var line in lines) {
          if (line.contains(mapValue) && !line.contains("\$")) {
            line = line.replaceAll(mapValue, "\${S.current.$key}");
          }
          newLines.add(line);
        }
        entity.writeAsStringSync(newLines.join("\n"));
      }
    }
  }
}

class CheckContainsVisitor extends GeneralizingAstVisitor {
  final String mapValue;

  CheckContainsVisitor(this.mapValue);

  bool hasValue = false;

  @override
  visitStringLiteral(StringLiteral node) {
    final value = node.stringValue ?? "";
    if (value == mapValue) {
      print('Found->visitStringLiteral: $value');
      hasValue = true;
    }
    return super.visitStringLiteral(node);
  }
}

class MyAstVisitor extends GeneralizingAstVisitor {
  @override
  visitStringLiteral(StringLiteral node) {
    final value = node.stringValue ?? "";
    if (containsChinese(value)) {
      print('Found->visitStringLiteral: $value');
      addStringResult(value);
    }
    return super.visitStringLiteral(node);
  }

  @override
  visitAdjacentStrings(AdjacentStrings node) {
    int interpolationIndex = 0;
    var result = '';
    for (var string in node.strings) {
      if (string is SimpleStringLiteral) {
        result += string.value;
      } else if (string is StringInterpolation) {
        for (var element in string.elements) {
          if (element is InterpolationString) {
            result += element.value;
          } else if (element is InterpolationExpression) {
            result += '{v${interpolationIndex++}}';
          }
        }
      }
    }
    if (containsChinese(result)) {
      print('Found->visitAdjacentStrings: $result');
      addStringResult(result);
    }
    return super.visitAdjacentStrings(node);
  }

  @override
  visitStringInterpolation(StringInterpolation node) {
    int interpolationIndex = 0;
    var result = '';
    for (var element in node.elements) {
      if (element is InterpolationString) {
        result += element.value;
      } else if (element is InterpolationExpression) {
        result += '{v${interpolationIndex++}}';
      }
    }
    if (containsChinese(result)) {
      print('Found->visitStringInterpolation: $result');
      addStringResult(result);
    }
    return super.visitStringInterpolation(node);
  }

  @override
  visitInterpolationExpression(InterpolationExpression node) {
    int interpolationIndex = 0;
    final value = '{v${interpolationIndex++}}';
    if (containsChinese(value)) {
      print('Found->visitInterpolationExpression: $value');
      addStringResult(value);
    }
    return super.visitInterpolationExpression(node);
  }

  bool containsChinese(String input) {
    return RegExp(r'[\u4e00-\u9fa5]').hasMatch(input);
  }

  addStringResult(String value) {
    stringResult.add(value);
  }
}
