import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/udb.dart';
import 'package:starcitizen_doctor/data/nav_api_data.dart';

part 'nav_state.freezed.dart';

part 'nav_state.g.dart';

@freezed
abstract class NavState with _$NavState {
  const factory NavState({
    List<NavApiDocsItemData>? items,
    @Default("") String errorInfo,
  }) = _NavState;
}

@riverpod
class Nav extends _$Nav {
  bool _mounted = true;

  @override
  NavState build() {
    state = NavState();
    loadData(1);
    ref.onDispose(() {
      _mounted = false;
    });
    return state;
  }

  void loadData(int pageNo) async {
    if (!_mounted) return;
    try {
      final r = await UDBNavApi.getNavItems(pageNo: pageNo);
      if (!_mounted) return;
      state = state.copyWith(items: r.docs, errorInfo: "");
    } catch (e) {
      if (!_mounted) return;
      state = state.copyWith(errorInfo: e.toString());
    }
  }
}
