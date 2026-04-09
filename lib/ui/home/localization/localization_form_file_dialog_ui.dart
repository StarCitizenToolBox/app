import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';
import 'package:starcitizen_doctor/ui/home/localization/localization_extension_selector.dart';
import 'package:starcitizen_doctor/ui/home/localization/localization_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class LocalizationFromFileDialogUI extends HookConsumerWidget {
  final bool isInAdvancedMode;

  const LocalizationFromFileDialogUI({super.key, this.isInAdvancedMode = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStringBuffer = useState<StringBuffer?>(null);
    final isLoading = useState(false);
    final installOptions = useState<LocalizationInstallOptions>(
      LocalizationInstallOptions(),
    );

    void onSelectFile() async {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: S.current.home_localization_select_customize_file_ini,
        type: FileType.custom,
        allowedExtensions: ["ini"],
        allowMultiple: false,
        lockParentWindow: true,
      );
      if (result == null || result.files.firstOrNull == null) return;
      isLoading.value = true;
      final file = result.files.first;
      final buffer = StringBuffer();
      final content = await File(file.path!).readAsString();
      for (final line in content.split("\n")) {
        if (line.startsWith("_starcitizen_doctor_")) continue;
        buffer.writeln(line);
      }
      selectedStringBuffer.value = buffer;

      // 加载用户缓存的选项
      final localizationState = ref.read(localizationUIModelProvider);
      final appBox = Hive.box("app_conf");
      final savedExtensionFiles = appBox.get("localization_extensions", defaultValue: <String>[]);
      final options = await LocalizationInstallOptions.loadFromCache(
        hasCommunityInputMethodData: localizationState.communityInputMethodLanguageData != null,
        defaultVehicleSorting: appBox.get("vehicle_sorting", defaultValue: false) ?? false,
        availableExtensions: localizationState.localizationExtensionList,
        savedExtensionFiles: savedExtensionFiles,
      );
      installOptions.value = options;

      isLoading.value = false;
    }

    useEffect(() {
      addPostFrameCallback(() => onSelectFile());
      return null;
    }, const []);

    final localizationState = ref.watch(localizationUIModelProvider);

    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: selectedStringBuffer.value == null
            ? MediaQuery.of(context).size.width * .5
            : MediaQuery.of(context).size.width * .75,
        maxHeight: MediaQuery.of(context).size.height * .8,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(FluentIcons.back, size: 22),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 12),
          Text(S.current.home_localization_select_customize_file),
          const Spacer(),
          if (selectedStringBuffer.value != null)
            FilledButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: Text(S.current.app_common_tip_confirm),
              ),
              onPressed: () async {
                final appBox = Hive.box("app_conf");
                await appBox.put("vehicle_sorting", installOptions.value.enableVehicleSorting);
                await appBox.put(
                  "localization_extensions",
                  installOptions.value.selectedExtensions.map((e) => e.file).toList(),
                );
                if (!context.mounted) return;
                Navigator.pop(context, (
                  selectedStringBuffer.value,
                  installOptions.value.enableCommunityInputMethod,
                  installOptions.value.selectedExtensions,
                ));
              },
            ),
        ],
      ),
      content: AnimatedSize(
        duration: const Duration(milliseconds: 130),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedStringBuffer.value == null)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .05),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FluentIcons.file_code,
                            size: 32,
                            color: Colors.white.withValues(alpha: .6),
                          ),
                          const SizedBox(height: 12),
                          Text(S.current.home_localization_action_select_customize_file),
                        ],
                      ),
                    ),
                    onPressed: onSelectFile,
                  ),
                ),
              )
            else if (isLoading.value) ...[
              makeLoading(context),
            ] else ...[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .05),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: CodeEditor(
                    controller: CodeLineEditingController.fromText(selectedStringBuffer.value.toString()),
                    readOnly: true,
                  ),
                ),
              ),
              if (!isInAdvancedMode) ...[
                const SizedBox(height: 16),
                LocalizationInstallOptionsPanel(
                  options: installOptions.value,
                  hasCommunityInputMethodData: localizationState.communityInputMethodLanguageData != null,
                  availableExtensions: localizationState.localizationExtensionList,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
