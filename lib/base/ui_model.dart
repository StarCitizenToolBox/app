import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui.dart';

export '../common/utils/base_utils.dart';
export 'ui.dart';

class BaseUIModel extends ChangeNotifier {
  String uiErrorMsg = "";
  bool _isDisposed = false;

  bool get mounted => !_isDisposed;

  BuildContext? context;

  BaseUIModel() {
    initModel();
  }

  @mustCallSuper
  void initModel() {
    dPrint("[base] <$runtimeType> Model Init");
    loadData();
  }

  @mustCallSuper
  @override
  void dispose() {
    _isDisposed = true;
    _childUIModels?.forEach((k, value) {
      (value as BaseUIModel).dispose();
      _childUIModels?[k] = null;
    });
    dPrint("[base] <$runtimeType> Model Disposed");
    super.dispose();
  }

  Future loadData() async {}

  Future reloadData() async {
    return loadData();
  }

  Future onErrorReloadData() async {
    return loadData();
  }

  @override
  void notifyListeners() {
    if (!mounted) return;
    super.notifyListeners();
  }

  Future<T?> handleError<T>(Future<T> Function() requestFunc,
      {bool showFullScreenError = false, String? errorOverride}) async {
    uiErrorMsg = "";
    if (mounted) notifyListeners();
    try {
      return await requestFunc();
    } catch (e) {
      dPrint("$runtimeType.handleError Error:$e");
      String errorMsg = "Unknown Error";
      // if (e is AppHttpResultData && stringIsNotEmpty(e.msg)) {
      //   errorMsg = e.msg!;
      //   return null;
      // } else {
      //   errorMsg = e.toString();
      // }
      errorMsg = e.toString();
      if (showFullScreenError) {
        uiErrorMsg = errorMsg;
        notifyListeners();
        return null;
      }
      showToast(context!, errorOverride ?? errorMsg);
    }
    return null;
  }

  Map<dynamic, dynamic>? _childUIModels;
  Map<dynamic, dynamic>? _childUIProviders;

  BaseUIModel? onCreateChildUIModel(modelKey) => null;

  dynamic _getChildUIModel(modelKey) {
    _childUIModels ??= {};
    final cachedModel = _childUIModels![modelKey];
    if (cachedModel != null) {
      return (cachedModel);
    }
    final newModel = onCreateChildUIModel(modelKey);
    _childUIModels![modelKey] = newModel!;
    return newModel;
  }

  ChangeNotifierProvider<M> getChildUIModelProviders<M extends BaseUIModel>(
      modelKey) {
    _childUIProviders ??= {};
    if (_childUIProviders![modelKey] == null) {
      _childUIProviders![modelKey] = ChangeNotifierProvider<M>((ref) {
        final c = (_getChildUIModel(modelKey) as M);
        return c..context = context;
      });
    }
    return _childUIProviders![modelKey]!;
  }

  T? getCreatedChildUIModel<T extends BaseUIModel>(String modelKey) {
    return _childUIModels?[modelKey] as T?;
  }

  Future<void> reloadAllChildModels() async {
    if (_childUIModels == null) return;
    final futureList = <Future>[];
    for (var value in _childUIModels!.entries) {
      futureList.add(value.value.reloadData());
    }
    await Future.wait(futureList);
    notifyListeners();
  }

  dismissKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
