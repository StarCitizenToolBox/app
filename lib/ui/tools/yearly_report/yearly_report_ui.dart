import 'package:animate_do/animate_do.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/helper/yearly_report_analyzer.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

part 'yearly_report_pages.dart';

class YearlyReportUI extends HookConsumerWidget {
  final List<String> logContents;
  final int year;

  const YearlyReportUI({super.key, required this.logContents, required this.year});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportData = useState<YearlyReportData?>(null);
    final isLoading = useState(true);
    final currentPage = useState(0);
    final loadingProgress = useState(0.0);
    final pageController = usePageController();

    useEffect(() {
      _loadReport(reportData, isLoading, loadingProgress);
      return null;
    }, const []);

    return Column(
      children: [
        Expanded(
          child: isLoading.value
              ? _buildLoadingPage(context, loadingProgress.value)
              : reportData.value == null
              ? _buildErrorPage(context)
              : _buildReportPages(context, reportData.value!, currentPage, pageController),
        ),
        _buildDisclaimer(context),
      ],
    );
  }

  Future<void> _loadReport(
    ValueNotifier<YearlyReportData?> reportData,
    ValueNotifier<bool> isLoading,
    ValueNotifier<double> loadingProgress,
  ) async {
    try {
      bool isGenerating = true;
      Future<void> progressAnimation() async {
        while (isGenerating && loadingProgress.value < 0.9) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (isGenerating) {
            final remaining = 0.9 - loadingProgress.value;
            loadingProgress.value += remaining * 0.02;
          }
        }
      }

      final progressFuture = progressAnimation();
      final report = await YearlyReportAnalyzer.generateReportFromContents(logContents, year);

      isGenerating = false;
      await progressFuture;

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
          SpinPerfect(
            infinite: true,
            duration: const Duration(seconds: 3),
            child: FadeIn(child: Icon(FontAwesomeIcons.rocket, size: 80, color: FluentTheme.of(context).accentColor)),
          ),
          const SizedBox(height: 40),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Text(
              S.current.yearly_report_generating,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: Text(
              S.current.yearly_report_analyzing_logs,
              style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6)),
            ),
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
            Text(S.current.yearly_report_error_title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              S.current.yearly_report_error_description,
              style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6)),
            ),
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
        PageView.builder(
          scrollDirection: Axis.vertical,
          controller: pageController,
          onPageChanged: (index) => currentPage.value = index,
          itemCount: pages.length,
          itemBuilder: (context, index) => pages[index],
        ),
        if (currentPage.value > 0)
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(child: _makeNavButton(pageController, currentPage.value - 1, true)),
          ),
        if (currentPage.value < pages.length - 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(child: _makeNavButton(pageController, currentPage.value + 1, false)),
          ),
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
            Text(isUp ? S.current.yearly_report_nav_prev : S.current.yearly_report_nav_next),
          ],
        ),
        onPressed: () =>
            pageCtrl.animateToPage(pageIndex, duration: const Duration(milliseconds: 300), curve: Curves.ease),
      ),
    );
  }

  List<Widget> _buildPageList(BuildContext context, YearlyReportData data) {
    return [
      _WelcomePage(year: year),
      _LaunchCountPage(data: data),
      _PlayTimePage(data: data),
      _SessionStatsPage(data: data),
      _MonthlyStatsPage(data: data),
      _StreakStatsPage(data: data),
      _CrashCountPage(data: data),
      _KillDeathPage(data: data),
      _EarliestPlayPage(data: data),
      _LatestPlayPage(data: data),
      _VehicleDestructionPage(data: data),
      _VehiclePilotedPage(data: data),
      _LocationStatsPage(data: data),
      _AccountStatsPage(data: data),
      _SummaryPage(year: year),
      _DataSummaryPage(data: data, year: year),
    ];
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      decoration: BoxDecoration(color: FluentTheme.of(context).cardColor.withValues(alpha: .15)),
      child: Text(
        S.current.yearly_report_disclaimer,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: .7)),
      ),
    );
  }
}
