import 'package:animate_do/animate_do.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/helper/yearly_report_analyzer.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class YearlyReportUI extends HookConsumerWidget {
  final List<String> gameInstallPaths;

  const YearlyReportUI({super.key, required this.gameInstallPaths});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportData = useState<YearlyReportData?>(null);
    final isLoading = useState(true);
    final currentPage = useState(0);
    final loadingProgress = useState(0.0);
    final pageController = usePageController();

    // 加载报告数据
    useEffect(() {
      _loadReport(reportData, isLoading, loadingProgress);
      return null;
    }, const []);

    return makeDefaultPage(
      context,
      title: "星际公民 2025 年度报告",
      useBodyContainer: true,
      content: Column(
        children: [
          Expanded(
            child: isLoading.value
                ? _buildLoadingPage(context, loadingProgress.value)
                : reportData.value == null
                ? _buildErrorPage(context)
                : _buildReportPages(context, reportData.value!, currentPage, pageController),
          ),
          // 底部提示
          _buildDisclaimer(context),
        ],
      ),
    );
  }

  Future<void> _loadReport(
    ValueNotifier<YearlyReportData?> reportData,
    ValueNotifier<bool> isLoading,
    ValueNotifier<double> loadingProgress,
  ) async {
    try {
      // 启动假进度条动画，缓慢前进到 90%
      bool isGenerating = true;
      Future<void> progressAnimation() async {
        while (isGenerating && loadingProgress.value < 0.9) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (isGenerating) {
            // 缓慢增加进度，越接近 90% 越慢
            final remaining = 0.9 - loadingProgress.value;
            loadingProgress.value += remaining * 0.02;
          }
        }
      }

      // 同时启动进度动画和实际加载
      final progressFuture = progressAnimation();
      final report = await YearlyReportAnalyzer.generateReport(gameInstallPaths, 2025);

      // 停止假进度动画
      isGenerating = false;
      await progressFuture;

      // 快速完成到 100%
      while (loadingProgress.value < 1.0) {
        await Future.delayed(const Duration(milliseconds: 20));
        loadingProgress.value = (loadingProgress.value + 0.05).clamp(0.0, 1.0);
      }
      await Future.delayed(const Duration(milliseconds: 300));

      reportData.value = report;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Widget _buildLoadingPage(BuildContext context, double progress) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 动画图标
          SpinPerfect(
            infinite: true,
            duration: const Duration(seconds: 3),
            child: FadeIn(child: Icon(FontAwesomeIcons.rocket, size: 80, color: FluentTheme.of(context).accentColor)),
          ),
          const SizedBox(height: 40),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Text("正在生成您的年度报告...", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: Text("正在分析游戏日志数据", style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6))),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 700),
            child: SizedBox(width: 300, child: ProgressBar(value: progress * 100)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPage(BuildContext context) {
    return Center(
      child: FadeInUp(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.error, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            Text("无法生成年度报告", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("请确保游戏目录正确且存在日志文件", style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6))),
          ],
        ),
      ),
    );
  }

  Widget _buildReportPages(
    BuildContext context,
    YearlyReportData data,
    ValueNotifier<int> currentPage,
    PageController pageController,
  ) {
    final pages = _buildPageList(context, data);

    return Stack(
      children: [
        // 页面内容 - 上下翻页
        PageView.builder(
          scrollDirection: Axis.vertical,
          controller: pageController,
          onPageChanged: (index) => currentPage.value = index,
          itemCount: pages.length,
          itemBuilder: (context, index) => pages[index],
        ),
        // 顶部导航按钮
        if (currentPage.value > 0)
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(child: _makeNavButton(pageController, currentPage.value - 1, true)),
          ),
        // 底部导航按钮
        if (currentPage.value < pages.length - 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(child: _makeNavButton(pageController, currentPage.value + 1, false)),
          ),
        // 页面指示器
        Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                pages.length,
                (index) => GestureDetector(
                  onTap: () => pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    width: 8,
                    height: currentPage.value == index ? 24 : 8,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: currentPage.value == index
                          ? FluentTheme.of(context).accentColor
                          : Colors.white.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _makeNavButton(PageController pageCtrl, int pageIndex, bool isUp) {
    return Bounce(
      child: IconButton(
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isUp ? FluentIcons.chevron_up : FluentIcons.chevron_down, size: 12),
            const SizedBox(width: 8),
            Text(isUp ? "上一页" : "继续查看"),
          ],
        ),
        onPressed: () =>
            pageCtrl.animateToPage(pageIndex, duration: const Duration(milliseconds: 300), curve: Curves.ease),
      ),
    );
  }

  List<Widget> _buildPageList(BuildContext context, YearlyReportData data) {
    return [
      // 欢迎页
      _buildWelcomePage(context),
      // 启动次数
      _buildLaunchCountPage(context, data),
      // 游玩时长
      _buildPlayTimePage(context, data),
      // 游玩时长详情
      _buildSessionStatsPage(context, data),
      // 月份统计
      _buildMonthlyStatsPage(context, data),
      // 连续游玩/离线统计
      _buildStreakStatsPage(context, data),
      // 崩溃次数
      _buildCrashCountPage(context, data),
      // 击杀统计 (K/D)
      _buildKillDeathPage(context, data),
      // 最早游玩
      _buildEarliestPlayPage(context, data),
      // 最晚游玩
      _buildLatestPlayPage(context, data),
      // 炸船统计
      _buildVehicleDestructionPage(context, data),
      // 载具驾驶统计
      _buildVehiclePilotedPage(context, data),
      // 地点统计
      _buildLocationStatsPage(context, data),
      // 账号统计
      _buildAccountStatsPage(context, data),
      // 感谢页
      _buildSummaryPage(context, data),
      // 数据大总结页
      _buildDataSummaryPage(context, data),
    ];
  }

  Widget _buildWelcomePage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(
            duration: const Duration(milliseconds: 600),
            child: Icon(FontAwesomeIcons.star, size: 80, color: Colors.yellow),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Text("2025 年度报告", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: Text("回顾您在星际公民中的精彩时刻", style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: .8))),
          ),
          const SizedBox(height: 48),
          FadeInUp(
            delay: const Duration(milliseconds: 700),
            child: Pulse(
              infinite: true,
              duration: const Duration(seconds: 2),
              child: Text("向下滚动或点击下方按钮开始", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .5))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaunchCountPage(BuildContext context, YearlyReportData data) {
    return _AnimatedStatPage(
      icon: FontAwesomeIcons.play,
      iconColor: Colors.green,
      title: "游戏启动次数",
      description: "今年您启动了游戏",
      mainValue: "${data.yearlyLaunchCount}",
      mainUnit: "次",
      secondaryLabel: "累计启动",
      secondaryValue: "${data.totalLaunchCount} 次",
    );
  }

  Widget _buildPlayTimePage(BuildContext context, YearlyReportData data) {
    final yearlyHours = data.yearlyPlayTime.inMinutes / 60;
    final totalHours = data.totalPlayTime.inMinutes / 60;

    return _AnimatedStatPage(
      icon: FontAwesomeIcons.clock,
      iconColor: Colors.blue,
      title: "游玩时长",
      description: "今年您在宇宙中遨游了",
      mainValue: yearlyHours.toStringAsFixed(1),
      mainUnit: "小时",
      secondaryLabel: "累计游玩",
      secondaryValue: "${totalHours.toStringAsFixed(1)} 小时",
    );
  }

  Widget _buildCrashCountPage(BuildContext context, YearlyReportData data) {
    return _AnimatedStatPage(
      icon: FontAwesomeIcons.bug,
      iconColor: Colors.orange,
      title: "游戏崩溃次数",
      description: "今年游戏不太稳定的时刻",
      mainValue: "${data.yearlyCrashCount}",
      mainUnit: "次",
      secondaryLabel: "累计崩溃",
      secondaryValue: "${data.totalCrashCount} 次",
      extraNote: data.yearlyCrashCount > 10 ? "希望明年能更稳定！" : "运气不错！",
    );
  }

  Widget _buildKillDeathPage(BuildContext context, YearlyReportData data) {
    final totalKD = data.yearlyKillCount + data.yearlyDeathCount;
    final kdRatio = data.yearlyDeathCount > 0
        ? (data.yearlyKillCount / data.yearlyDeathCount).toStringAsFixed(2)
        : data.yearlyKillCount > 0
        ? "∞"
        : "0.00";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.crosshairs, size: 64, color: Colors.red)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text("击杀统计", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
          // K/D 比率大显示
          if (totalKD > 0)
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("K/D", style: TextStyle(fontSize: 24, color: Colors.white.withValues(alpha: .6))),
                  const SizedBox(width: 16),
                  Text(
                    kdRatio,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: double.tryParse(kdRatio) != null && double.parse(kdRatio) >= 1.0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 32),
          // 详细数据 - 等宽卡片
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(FontAwesomeIcons.skull, size: 24, color: Colors.green),
                        const SizedBox(height: 8),
                        Text("击杀", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6))),
                        const SizedBox(height: 4),
                        Text(
                          "${data.yearlyKillCount}",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(FontAwesomeIcons.skullCrossbones, size: 24, color: Colors.red),
                        const SizedBox(height: 8),
                        Text("死亡", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6))),
                        const SizedBox(height: 4),
                        Text(
                          "${data.yearlyDeathCount}",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(FontAwesomeIcons.personFalling, size: 24, color: Colors.orange),
                        const SizedBox(height: 8),
                        Text("自杀", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6))),
                        const SizedBox(height: 4),
                        Text(
                          "${data.yearlySelfKillCount}",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (totalKD == 0)
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Text("今年没有检测到击杀/死亡记录", style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6))),
            ),
        ],
      ),
    );
  }

  Widget _buildEarliestPlayPage(BuildContext context, YearlyReportData data) {
    final time = data.earliestPlayDate;
    final timeStr = time != null
        ? "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"
        : "暂无数据";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.sun, size: 64, color: Colors.orange)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text("最早的一次游玩", style: TextStyle(fontSize: 24, color: Colors.white.withValues(alpha: .8))),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Text(timeStr, style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          if (time != null)
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Text(
                "您在清晨 ${time.month} 月 ${time.day} 日开始了星际之旅",
                style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLatestPlayPage(BuildContext context, YearlyReportData data) {
    final time = data.latestPlayDate;
    final timeStr = time != null
        ? "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"
        : "暂无数据";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.moon, size: 64, color: Colors.purple)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text("最晚的一次游玩", style: TextStyle(fontSize: 24, color: Colors.white.withValues(alpha: .8))),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Text(timeStr, style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          if (time != null)
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Text(
                "深夜 ${time.month} 月 ${time.day} 日还在探索宇宙",
                style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVehicleDestructionPage(BuildContext context, YearlyReportData data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.explosion, size: 64, color: Colors.red)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text("载具损毁统计", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Text("今年您共炸了", style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: .7))),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${data.yearlyVehicleDestructionCount}",
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 8),
                  child: Text("艘船", style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (data.mostDestroyedVehicle != null)
            FadeInUp(
              delay: const Duration(milliseconds: 700),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text("炸的最多的船", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
                    const SizedBox(height: 8),
                    Text(data.mostDestroyedVehicle!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                      "炸了 ${data.mostDestroyedVehicleCount} 次",
                      style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .8)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVehiclePilotedPage(BuildContext context, YearlyReportData data) {
    final showDetails = useState(false);
    final scrollController = useScrollController();
    final sortedVehicles = data.vehiclePilotedDetails.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(child: Icon(FontAwesomeIcons.shuttleSpace, size: 64, color: Colors.teal)),
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Text("载具驾驶统计", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
            if (data.mostPilotedVehicle != null)
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text("最常驾驶的载具", style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .9))),
                      const SizedBox(height: 12),
                      Text(data.mostPilotedVehicle!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(
                        "驾驶了 ${data.mostPilotedVehicleCount} 次",
                        style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .8)),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // 展开查看全部按钮
            if (sortedVehicles.length > 1)
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Column(
                  children: [
                    IconButton(
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(showDetails.value ? FluentIcons.chevron_up : FluentIcons.chevron_down, size: 12),
                          const SizedBox(width: 8),
                          Text(showDetails.value ? "收起详情" : "查看全部 ${sortedVehicles.length} 个载具"),
                        ],
                      ),
                      onPressed: () => showDetails.value = !showDetails.value,
                    ),
                    if (showDetails.value)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: 120,
                        width: double.infinity,
                        child: Center(
                          child: Listener(
                            onPointerSignal: (event) {
                              if (event is PointerScrollEvent) {
                                final newOffset = scrollController.offset + event.scrollDelta.dy;
                                final canScroll =
                                    newOffset >= scrollController.position.minScrollExtent &&
                                    newOffset <= scrollController.position.maxScrollExtent;
                                if (canScroll) {
                                  scrollController.jumpTo(newOffset);
                                }
                                // 消费滚动事件，阻止向上冒泡触发页面滚动
                              }
                            },
                            behavior: HitTestBehavior.opaque,
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (_) => true, // 消费所有滚动通知
                              child: SingleChildScrollView(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                physics: const ClampingScrollPhysics(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: sortedVehicles.map((vehicle) {
                                    return Container(
                                      width: 140,
                                      margin: const EdgeInsets.symmetric(horizontal: 6),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            vehicle.key,
                                            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .9)),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "${vehicle.value}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "次",
                                            style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .6)),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStatsPage(BuildContext context, YearlyReportData data) {
    final showDetails = useState(false);
    final scrollController = useScrollController();
    final sortedAccounts = data.accountSessionDetails.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.userAstronaut, size: 64, color: Colors.blue)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text("账号统计", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
          if (data.mostPlayedAccount != null)
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text("最常使用的账号", style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .9))),
                    const SizedBox(height: 12),
                    Text(data.mostPlayedAccount!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(
                      "登录了 ${data.mostPlayedAccountSessionCount} 次",
                      style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .8)),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: Text(
              "共检测到 ${data.accountCount} 个账号",
              style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .5)),
            ),
          ),
          // 展开查看全部按钮
          if (sortedAccounts.length > 1)
            FadeInUp(
              delay: const Duration(milliseconds: 700),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  IconButton(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(showDetails.value ? FluentIcons.chevron_up : FluentIcons.chevron_down, size: 12),
                        const SizedBox(width: 8),
                        Text(showDetails.value ? "收起详情" : "查看全部账号"),
                      ],
                    ),
                    onPressed: () => showDetails.value = !showDetails.value,
                  ),
                  if (showDetails.value)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      height: 100,
                      width: double.infinity,
                      child: Center(
                        child: Listener(
                          onPointerSignal: (event) {
                            if (event is PointerScrollEvent) {
                              final newOffset = scrollController.offset + event.scrollDelta.dy;
                              if (newOffset >= scrollController.position.minScrollExtent &&
                                  newOffset <= scrollController.position.maxScrollExtent) {
                                scrollController.jumpTo(newOffset);
                              }
                            }
                          },
                          child: SingleChildScrollView(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: sortedAccounts.map((account) {
                                return Container(
                                  width: 120,
                                  margin: const EdgeInsets.symmetric(horizontal: 6),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        account.key,
                                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .9)),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${account.value}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "次",
                                        style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .6)),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 格式化时长
  String _formatDuration(Duration? duration) {
    if (duration == null) return "暂无数据";
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return "$hours 小时 $minutes 分钟";
    }
    return "$minutes 分钟";
  }

  Widget _buildSessionStatsPage(BuildContext context, YearlyReportData data) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(child: Icon(FontAwesomeIcons.stopwatch, size: 64, color: Colors.teal)),
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Text("游玩时长详情", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
            // 横排显示三个时长卡片
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 平均时长
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(FontAwesomeIcons.chartLine, size: 16, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text("平均", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatDuration(data.averageSessionTime),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 最长游玩
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(FontAwesomeIcons.arrowUp, size: 16, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text("最长", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatDuration(data.longestSession),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                textAlign: TextAlign.center,
                              ),
                              if (data.longestSessionDate != null)
                                Text(
                                  "${data.longestSessionDate!.month}月${data.longestSessionDate!.day}日",
                                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 最短游玩
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(FontAwesomeIcons.arrowDown, size: 16, color: Colors.orange),
                                  const SizedBox(width: 8),
                                  Text("最短", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatDuration(data.shortestSession),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                                textAlign: TextAlign.center,
                              ),
                              if (data.shortestSessionDate != null)
                                Text(
                                  "${data.shortestSessionDate!.month}月${data.shortestSessionDate!.day}日",
                                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Text(
                "(最短仅统计超过 5 分钟的游戏)",
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 月份名称
  String _getMonthName(int month) {
    return "$month月";
  }

  Widget _buildMonthlyStatsPage(BuildContext context, YearlyReportData data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.calendarDays, size: 64, color: Colors.blue)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text("月份统计", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
          // 并排展示
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 游玩最多的月份
                if (data.mostPlayedMonth != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(FontAwesomeIcons.fire, size: 18, color: Colors.orange),
                            const SizedBox(width: 10),
                            Text("游玩最多", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getMonthName(data.mostPlayedMonth!),
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        Text(
                          "启动了 ${data.mostPlayedMonthCount} 次",
                          style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .7)),
                        ),
                      ],
                    ),
                  ),
                // 游玩最少的月份
                if (data.leastPlayedMonth != null && data.leastPlayedMonth != data.mostPlayedMonth)
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(FontAwesomeIcons.snowflake, size: 18, color: Colors.teal),
                            const SizedBox(width: 10),
                            Text("游玩最少", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getMonthName(data.leastPlayedMonth!),
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        Text(
                          "仅启动 ${data.leastPlayedMonthCount} 次",
                          style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .7)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakStatsPage(BuildContext context, YearlyReportData data) {
    String formatDateRange(DateTime? start, DateTime? end) {
      if (start == null || end == null) return "";
      return "${start.month}月${start.day}日 - ${end.month}月${end.day}日";
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.fire, size: 64, color: Colors.red)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text("连续记录", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
          // 并排展示
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 连续游玩天数
                if (data.longestPlayStreak > 0)
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(FontAwesomeIcons.gamepad, size: 18, color: Colors.green),
                            const SizedBox(width: 10),
                            Text("连续游玩", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${data.longestPlayStreak}",
                              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6, left: 4),
                              child: Text("天", style: TextStyle(fontSize: 18, color: Colors.green)),
                            ),
                          ],
                        ),
                        if (data.playStreakStartDate != null)
                          Text(
                            formatDateRange(data.playStreakStartDate, data.playStreakEndDate),
                            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
                          ),
                      ],
                    ),
                  ),
                // 连续离线天数
                if (data.longestOfflineStreak > 0)
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(FontAwesomeIcons.bed, size: 18, color: Colors.grey),
                            const SizedBox(width: 10),
                            Text("连续离线", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${data.longestOfflineStreak}",
                              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6, left: 4),
                              child: Text("天", style: TextStyle(fontSize: 18, color: Colors.grey)),
                            ),
                          ],
                        ),
                        if (data.offlineStreakStartDate != null)
                          Text(
                            formatDateRange(data.offlineStreakStartDate, data.offlineStreakEndDate),
                            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatsPage(BuildContext context, YearlyReportData data) {
    final scrollController = ScrollController();

    if (data.topLocations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(child: Icon(FontAwesomeIcons.locationDot, size: 64, color: Colors.grey)),
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Text("地点统计", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Text("暂无地点访问记录", style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6))),
            ),
          ],
        ),
      );
    }

    // 将地点分成3行
    final locations = data.topLocations;
    final rowCount = 3;
    final List<List<MapEntry<String, int>>> rows = List.generate(rowCount, (_) => []);
    for (int i = 0; i < locations.length; i++) {
      rows[i % rowCount].add(locations[i]);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.locationDot, size: 64, color: Colors.red)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text("常去的地点", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Text("基于库存查看记录统计", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6))),
          ),
          const SizedBox(height: 24),
          // 三排瀑布流横向滑动
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: GestureDetector(
                onVerticalDragUpdate: (_) {}, // 拦截垂直拖拽
                child: Listener(
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      // 注册为唯一的滚轮事件处理者，阻止冒泡
                      GestureBinding.instance.pointerSignalResolver.register(event, (event) {
                        final scrollEvent = event as PointerScrollEvent;
                        final newOffset = scrollController.offset + scrollEvent.scrollDelta.dy;
                        final clampedOffset = newOffset.clamp(
                          scrollController.position.minScrollExtent,
                          scrollController.position.maxScrollExtent,
                        );
                        scrollController.jumpTo(clampedOffset);
                      });
                    }
                  },
                  child: Center(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: rows.asMap().entries.map((rowEntry) {
                          final rowIndex = rowEntry.key;
                          final rowLocations = rowEntry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: rowLocations.asMap().entries.map((locEntry) {
                                final actualIndex = locEntry.key * rowCount + rowIndex;
                                final location = locEntry.value;
                                final isTop3 = actualIndex < 3;
                                return Container(
                                  width: 200,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: isTop3
                                        ? FluentTheme.of(context).accentColor.withValues(alpha: .2 - actualIndex * 0.05)
                                        : FluentTheme.of(context).cardColor.withValues(alpha: .1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: isTop3
                                              ? Colors.yellow.withValues(alpha: 1 - actualIndex * 0.3)
                                              : Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${actualIndex + 1}",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: isTop3 ? Colors.black : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              location.key,
                                              style: TextStyle(fontSize: 11),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              "${location.value} 次",
                                              style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .5)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPage(BuildContext context, YearlyReportData data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.trophy, size: 80, color: Colors.yellow)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Text("感谢您的陪伴", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: Text(
              "2025 年，我们一起在星际公民中\n创造了无数精彩回忆",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: .8)),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 700),
            child: Text("期待 2026 年继续与您相伴！", style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6))),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSummaryPage(BuildContext context, YearlyReportData data) {
    final yearlyHours = data.yearlyPlayTime.inMinutes / 60;

    // 构建数据项列表
    final dataItems = <_SummaryGridItem>[
      _SummaryGridItem("启动游戏", "${data.yearlyLaunchCount}", "次", FontAwesomeIcons.play, Colors.green, isWide: false),
      _SummaryGridItem(
        "游玩时长",
        yearlyHours.toStringAsFixed(1),
        "小时",
        FontAwesomeIcons.clock,
        Colors.blue,
        isWide: false,
      ),
      _SummaryGridItem("游戏崩溃", "${data.yearlyCrashCount}", "次", FontAwesomeIcons.bug, Colors.orange, isWide: false),
      _SummaryGridItem(
        "击杀",
        "${data.yearlyKillCount}",
        "次",
        FontAwesomeIcons.crosshairs,
        Colors.green,
        isWide: false,
      ),
      _SummaryGridItem("死亡", "${data.yearlyDeathCount}", "次", FontAwesomeIcons.skull, Colors.red, isWide: false),
      _SummaryGridItem(
        "载具损毁",
        "${data.yearlyVehicleDestructionCount}",
        "次",
        FontAwesomeIcons.explosion,
        Colors.red,
        isWide: false,
      ),
      if (data.longestSession != null)
        _SummaryGridItem(
          "最长在线",
          (data.longestSession!.inMinutes / 60).toStringAsFixed(1),
          "小时",
          FontAwesomeIcons.hourglassHalf,
          Colors.purple,
          isWide: false,
        ),
      // 常去位置单独处理，不放在网格中
      if (data.earliestPlayDate != null)
        _SummaryGridItem(
          "最早时刻",
          "${data.earliestPlayDate!.hour.toString().padLeft(2, '0')}:${data.earliestPlayDate!.minute.toString().padLeft(2, '0')}",
          "",
          FontAwesomeIcons.sun,
          Colors.orange,
          isWide: false,
        ),
      if (data.latestPlayDate != null)
        _SummaryGridItem(
          "最晚时刻",
          "${data.latestPlayDate!.hour.toString().padLeft(2, '0')}:${data.latestPlayDate!.minute.toString().padLeft(2, '0')}",
          "",
          FontAwesomeIcons.moon,
          Colors.purple,
          isWide: false,
        ),
      _SummaryGridItem(
        "重开次数",
        "${data.yearlySelfKillCount}",
        "次",
        FontAwesomeIcons.personFalling,
        Colors.grey,
        isWide: false,
      ),
      // 月份统计
      if (data.mostPlayedMonth != null)
        _SummaryGridItem(
          "最热月",
          _getMonthName(data.mostPlayedMonth!),
          "",
          FontAwesomeIcons.fire,
          Colors.orange,
          isWide: false,
        ),
      // 连续游玩/离线
      if (data.longestPlayStreak > 0)
        _SummaryGridItem(
          "连续游玩",
          "${data.longestPlayStreak}",
          "天",
          FontAwesomeIcons.gamepad,
          Colors.green,
          isWide: false,
        ),
      if (data.longestOfflineStreak > 0)
        _SummaryGridItem("连续离线", "${data.longestOfflineStreak}", "天", FontAwesomeIcons.bed, Colors.grey, isWide: false),
      // 常去位置和最爱载具
      if (data.topLocations.isNotEmpty)
        _SummaryGridItem(
          "常去位置",
          data.topLocations.first.key,
          "",
          FontAwesomeIcons.locationDot,
          Colors.red,
          isWide: true, // 使用较小字体
        ),
      if (data.mostPilotedVehicle != null)
        _SummaryGridItem(
          "最爱载具",
          data.mostPilotedVehicle!,
          "",
          FontAwesomeIcons.shuttleSpace,
          Colors.teal,
          isWide: true, // 使用较小字体
        ),
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          children: [
            // 标题
            FadeInDown(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.star, size: 20, color: Colors.yellow),
                  const SizedBox(width: 12),
                  Text(
                    "星际公民 2025 年度报告",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Icon(FontAwesomeIcons.star, size: 20, color: Colors.yellow),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 主账号
            if (data.mostPlayedAccount != null)
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  data.mostPlayedAccount!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            const SizedBox(height: 20),
            // 数据网格
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 5,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: dataItems.length,
                  itemBuilder: (context, index) {
                    final item = dataItems[index];
                    final isSmallFont = item.isWide; // 载具和位置使用较小字体
                    return Container(
                      height: 150,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: .05)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item.icon, size: 20, color: item.color.withValues(alpha: .8)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  item.value,
                                  style: TextStyle(
                                    fontSize: isSmallFont ? 16 : 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.0,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: isSmallFont ? 2 : null,
                                  overflow: isSmallFont ? TextOverflow.ellipsis : null,
                                ),
                              ),
                              if (item.unit.isNotEmpty) ...[
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    item.unit,
                                    style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.label,
                            style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .5)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 底部标识
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Text(
                "由 SC 汉化盒子为您呈现",
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      decoration: BoxDecoration(color: FluentTheme.of(context).cardColor.withValues(alpha: .15)),
      child: Text(
        "数据使用您的本地日志生成，不会发送到任何第三方。因跨版本 Log 改动较大，数据可能不完整，仅供娱乐。",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: .7)),
      ),
    );
  }
}

/// 总结网格项数据
class _SummaryGridItem {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final bool isWide;

  const _SummaryGridItem(this.label, this.value, this.unit, this.icon, this.color, {this.isWide = false});
}

/// 动画统计页面
class _AnimatedStatPage extends HookWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String mainValue;
  final String mainUnit;
  final String secondaryLabel;
  final String secondaryValue;
  final String? extraNote;

  const _AnimatedStatPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.mainValue,
    required this.mainUnit,
    required this.secondaryLabel,
    required this.secondaryValue,
    this.extraNote,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(icon, size: 64, color: iconColor)),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(title, style: TextStyle(fontSize: 24, color: Colors.white.withValues(alpha: .8))),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Text(description, style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6))),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(mainValue, style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, left: 8),
                  child: Text(mainUnit, style: TextStyle(fontSize: 24, color: Colors.white.withValues(alpha: .7))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SlideInRight(
            delay: const Duration(milliseconds: 800),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: FluentTheme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(secondaryLabel, style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6))),
                  const SizedBox(width: 12),
                  Text(secondaryValue, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          if (extraNote != null) ...[
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: Text(
                extraNote!,
                style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .5), fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
