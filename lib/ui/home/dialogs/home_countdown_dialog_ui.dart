import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class HomeCountdownDialogUI extends HookConsumerWidget {
  const HomeCountdownDialogUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeUIModelProvider);
    return ContentDialog(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .65),
      title: Row(
        children: [
          IconButton(
              icon: const Icon(
                FluentIcons.back,
                size: 22,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          const SizedBox(width: 12),
          Text(S.current.home_holiday_countdown),
        ],
      ),
      content: homeState.countdownFestivalListData == null
          ? makeLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    AlignedGridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: homeState.countdownFestivalListData!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final item =
                            homeState.countdownFestivalListData![index];
                        return Container(
                          decoration: BoxDecoration(
                            color: FluentTheme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                if (item.icon != null && item.icon != "") ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: Image.asset(
                                      "assets/countdown/${item.icon}",
                                      width: 38,
                                      height: 38,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ] else
                                  const SizedBox(width: 50),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item.name}",
                                    ),
                                    CountdownTimeText(
                                      targetTime:
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.time ?? 0),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      S.current.home_holiday_countdown_disclaimer,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: .3)),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
