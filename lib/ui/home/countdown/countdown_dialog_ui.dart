import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/widgets/countdown_time_text.dart';

import 'countdown_dialog_ui_model.dart';

class CountdownDialogUI extends BaseUI<CountdownDialogUIModel> {
  @override
  Widget? buildBody(BuildContext context, CountdownDialogUIModel model) {
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
              onPressed: model.onBack),
          const SizedBox(width: 12),
          const Text("节日倒计时"),
        ],
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(
            children: [
              AlignedGridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemCount: model.countdownFestivalListData.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final item = model.countdownFestivalListData[index];
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
                                targetTime: DateTime.fromMillisecondsSinceEpoch(
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
                "* 以上节日日期由人工收录、维护，可能存在错误，欢迎反馈！",
                style: TextStyle(
                    fontSize: 13, color: Colors.white.withOpacity(.3)),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  String getUITitle(BuildContext context, CountdownDialogUIModel model) => "";
}
