import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/localization/advanced_localization_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class AdvancedLocalizationUI extends HookConsumerWidget {
  const AdvancedLocalizationUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(advancedLocalizationUIModelProvider);
    final homeUIState = ref.watch(homeUIModelProvider);
    return makeDefaultPage(
        title: "高级汉化 -> ${homeUIState.scInstalledPath}",
        context,
        content: state.workingText.isNotEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ProgressRing(),
                    const SizedBox(height: 12),
                    Text(state.workingText),
                  ],
                ),
              )
            : _makeBody(context, homeUIState, state, ref));
  }

  Widget _makeBody(BuildContext context, HomeUIModelState homeUIState,
      AdvancedLocalizationUIState state, WidgetRef ref) {
    return AlignedGridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      padding: const EdgeInsets.all(12),
      itemBuilder: (BuildContext context, int index) {
        final item = state.classMap!.values.elementAt(index);
        return Container(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "${item.className}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                    Text(
                      "${item.valuesMap.length}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6, bottom: 12),
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.white.withOpacity(.1),
              ),
              SizedBox(
                height: 160,
                child: SuperListView.builder(
                  itemCount: item.valuesMap.length,
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final itemKey = item.valuesMap.keys.elementAt(index);
                    return Text(
                      "${item.valuesMap[itemKey]}",
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      itemCount: state.classMap?.length ?? 0,
    );
  }
}
