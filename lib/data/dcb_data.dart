/// DCB 记录项数据
class DcbRecordData {
  final String path;
  final int index;

  const DcbRecordData({required this.path, required this.index});
}

/// DCB 搜索匹配数据
class DcbSearchMatchData {
  final int lineNumber;
  final String lineContent;

  const DcbSearchMatchData({required this.lineNumber, required this.lineContent});
}

/// DCB 搜索结果数据
class DcbSearchResultData {
  final String path;
  final int index;
  final List<DcbSearchMatchData> matches;

  const DcbSearchResultData({required this.path, required this.index, required this.matches});
}
