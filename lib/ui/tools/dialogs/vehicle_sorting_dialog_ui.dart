import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

class VehicleSortingDialogUi extends HookConsumerWidget {
  final ValueNotifier<String> iniStringData;

  const VehicleSortingDialogUi({
    super.key,
    required this.iniStringData,
  });

  static const List<String> vehicleLineRegExpList = ["vehicle_Name.*"];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leftVehiclesList = useState<List<MapEntry<String, String>>?>(null);
    final rightVehiclesList = useState<List<MapEntry<String, String>>>([]);
    final leftSearchKey = useState<String>("");
    final leftSearchController = useTextEditingController();

    useEffect(() {
      _loadVehiclesList(leftVehiclesList, rightVehiclesList);
      return () {
        _saveSortedVehicles(rightVehiclesList.value);
      };
    }, const []);

    if (leftVehiclesList.value == null) {
      return const Center(child: ProgressRing());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .03),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(S.current.tools_vehicle_sorting_info),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Row(
            children: [
              // 左侧载具列表
              Expanded(
                flex: 2,
                child: Card(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    top: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          S.current.tools_vehicle_sorting_vehicle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormBox(
                                controller: leftSearchController,
                                placeholder: S.current.tools_vehicle_sorting_search,
                                onChanged: (value) {
                                  leftSearchKey.value = value;
                                },
                              ),
                            ),
                            SizedBox(width: 6),
                            // clear button
                            Button(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                child: const Icon(FluentIcons.clear),
                              ),
                              onPressed: () {
                                leftSearchKey.value = "";
                                leftSearchController.clear();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: leftVehiclesList.value!.length,
                          padding: EdgeInsets.only(right: 8),
                          itemBuilder: (context, index) {
                            final vehicle = leftVehiclesList.value![index];
                            if (leftSearchKey.value.isNotEmpty) {
                              // 如果搜索关键字不为空，则过滤列表
                              // key value 匹配
                              if (!vehicle.key.toLowerCase().contains(leftSearchKey.value.toLowerCase()) &&
                                  !vehicle.value.toLowerCase().contains(leftSearchKey.value.toLowerCase())) {
                                return const SizedBox.shrink();
                              }
                            }
                            return Draggable<MapEntry<String, String>>(
                              data: vehicle,
                              feedback: _buildVehicleItem(context, vehicle, (MediaQuery.of(context).size.width / 3)),
                              childWhenDragging: _buildVehicleItem(context, vehicle, null, opacity: 0.5),
                              child: _buildVehicleItem(context, vehicle, null),
                              onDragCompleted: () {
                                // 当拖动完成后，从左侧列表移除
                                final updatedList = [...leftVehiclesList.value!];
                                updatedList.removeAt(index);
                                leftVehiclesList.value = updatedList;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 右侧载具列表（已排序）a
              Expanded(
                flex: 3,
                child: Card(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    top: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          S.current.tools_vehicle_sorting_sorted,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: DragTarget<MapEntry<String, String>>(
                          onAcceptWithDetails: (detail) {
                            // 接受从左侧拖过来的数据
                            final updatedList = [...rightVehiclesList.value];
                            updatedList.add(detail.data);
                            rightVehiclesList.value = updatedList;
                            _applyChanges(rightVehiclesList.value);
                          },
                          builder: (context, candidateData, rejectedData) {
                            return ReorderableListView.builder(
                              buildDefaultDragHandles: false,
                              padding: EdgeInsets.only(right: 8.0),
                              onReorder: (oldIndex, newIndex) {
                                final updatedList = [...rightVehiclesList.value];
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final item = updatedList.removeAt(oldIndex);
                                updatedList.insert(newIndex, item);
                                rightVehiclesList.value = updatedList;
                              },
                              onReorderEnd: (_) {
                                _applyChanges(rightVehiclesList.value);
                              },
                              itemCount: rightVehiclesList.value.length,
                              itemBuilder: (context, index) {
                                final vehicle = rightVehiclesList.value[index];
                                // 创建带有前缀的显示值
                                final prefixedValue = _getPrefixedValue(index, vehicle.value);

                                return Container(
                                  key: ValueKey(vehicle.key + index.toString()),
                                  margin: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(FluentIcons.delete),
                                        onPressed: () {
                                          // 从右侧移除，添加回左侧
                                          final updatedRightList = [...rightVehiclesList.value];
                                          final removed = updatedRightList.removeAt(index);
                                          rightVehiclesList.value = updatedRightList;

                                          final updatedLeftList = [...leftVehiclesList.value!];
                                          updatedLeftList.add(removed);
                                          leftVehiclesList.value = updatedLeftList;
                                          _applyChanges(rightVehiclesList.value);
                                        },
                                      ),
                                      Expanded(
                                        child: ReorderableDragStartListener(
                                          index: index,
                                          child: _buildVehicleItem(
                                            context,
                                            MapEntry(vehicle.key, prefixedValue),
                                            null,
                                            isRightList: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleItem(BuildContext context, MapEntry<String, String> vehicle, double? width,
      {double opacity = 1.0, bool isRightList = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Opacity(
        opacity: opacity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vehicle.value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              vehicle.key,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(
                  alpha: .4,
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getPrefixedValue(int index, String originalValue) {
    // 生成前缀 (001, 002, etc.)
    final prefix = (index + 1).toString().padLeft(3, '0');
    return "$prefix - $originalValue";
  }

  void _applyChanges(List<MapEntry<String, String>> sortedVehicles) async {
    final lines = iniStringData.value.split('\n');
    final updatedLines = <String>[];

    for (final line in lines) {
      bool matched = false;
      final lineKey = line.split('=')[0].trim();
      for (var i = 0; i < sortedVehicles.length; i++) {
        final vehicle = sortedVehicles[i];
        if (lineKey == vehicle.key) {
          // 使用新的前缀值替换
          final prefixedValue = _getPrefixedValue(i, vehicle.value);
          updatedLines.add("$lineKey=$prefixedValue");
          matched = true;
          break;
        }
      }
      if (!matched) {
        updatedLines.add(line);
      }
    }
    iniStringData.value = updatedLines.join('\n');
    dPrint("[VehicleSortingDialogUi] Applied changes to ${sortedVehicles.length} vehicles");
  }

  Future<void> _saveSortedVehicles(List<MapEntry<String, String>> sortedVehicles) async {
    final appBox = await Hive.openBox("app_conf");
    appBox.put("sorted_vehicles", sortedVehicles.map((e) => e.key).toList());
    dPrint("[VehicleSortingDialogUi] Saved sorted vehicles: ${sortedVehicles.length}");
  }

  void _loadVehiclesList(
    ValueNotifier<List<MapEntry<String, String>>?> vehiclesList,
    ValueNotifier<List<MapEntry<String, String>>> rightVehiclesList,
  ) async {
    final vehicleMap = <String, String>{};
    final lines = iniStringData.value.split('\n');
    for (final regExp in vehicleLineRegExpList) {
      final pattern = RegExp(regExp);
      for (final line in lines) {
        if (pattern.hasMatch(line)) {
          final parts = line.split('=');
          if (parts.length == 2) {
            final key = parts[0].trim();
            final value = parts[1].trim();
            // 过滤掉短名称
            if (key.toLowerCase().endsWith("_short") || key.toLowerCase().endsWith("_short,p")) continue;
            vehicleMap[key] = value;
          }
        }
      }
    }
    vehiclesList.value = vehicleMap.entries.toList();
    dPrint("[VehicleSortingDialogUi] Loaded vehicles: ${vehiclesList.value?.length ?? 0}");

    // Load sorted vehicles from app_conf
    final appBox = await Hive.openBox("app_conf");
    final sortedVehicles = appBox.get("sorted_vehicles", defaultValue: <String>[]) as List<String>;
    if (sortedVehicles.isNotEmpty) {
      // 只保留有效载具
      rightVehiclesList.value = sortedVehicles
          .where((key) => vehicleMap.containsKey(key))
          .map((key) => MapEntry(key, vehicleMap[key]!))
          .toList();
      dPrint("[VehicleSortingDialogUi] Loaded sorted vehicles: ${rightVehiclesList.value.length}");
    }
  }
}
