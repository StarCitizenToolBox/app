part of 'yearly_report_ui.dart';

// Helper classes
class _SummaryGridItem {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final bool isWide;
  const _SummaryGridItem(this.label, this.value, this.unit, this.icon, this.color, {this.isWide = false});
}

String _formatDuration(Duration? duration) {
  if (duration == null) return S.current.yearly_report_no_data;
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours > 0) return S.current.yearly_report_duration_hours_minutes(hours, minutes);
  return S.current.yearly_report_duration_minutes(minutes);
}

String _getMonthName(int month) => S.current.yearly_report_month_format(month);

// Page Widgets
class _WelcomePage extends StatelessWidget {
  final int year;
  const _WelcomePage({required this.year});
  @override
  Widget build(BuildContext context) {
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
            child: Text(
              S.current.yearly_report_welcome_title(year.toString()),
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: Text(
              S.current.yearly_report_welcome_subtitle,
              style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: .8)),
            ),
          ),
          const SizedBox(height: 48),
          FadeInUp(
            delay: const Duration(milliseconds: 700),
            child: Pulse(
              infinite: true,
              duration: const Duration(seconds: 2),
              child: Text(
                S.current.yearly_report_welcome_hint,
                style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedStatPage extends StatelessWidget {
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

class _LaunchCountPage extends StatelessWidget {
  final YearlyReportData data;
  const _LaunchCountPage({required this.data});
  @override
  Widget build(BuildContext context) => _AnimatedStatPage(
    icon: FontAwesomeIcons.play,
    iconColor: Colors.green,
    title: S.current.yearly_report_launch_count_title,
    description: S.current.yearly_report_launch_count_desc,
    mainValue: "${data.yearlyLaunchCount}",
    mainUnit: S.current.about_analytics_units_times,
    secondaryLabel: S.current.yearly_report_launch_count_label,
    secondaryValue: S.current.yearly_report_launch_count_value(data.totalLaunchCount),
  );
}

class _PlayTimePage extends StatelessWidget {
  final YearlyReportData data;
  const _PlayTimePage({required this.data});
  @override
  Widget build(BuildContext context) {
    final yearlyHours = data.yearlyPlayTime.inMinutes / 60;
    final totalHours = data.totalPlayTime.inMinutes / 60;
    return _AnimatedStatPage(
      icon: FontAwesomeIcons.clock,
      iconColor: Colors.blue,
      title: S.current.yearly_report_play_time_title,
      description: S.current.yearly_report_play_time_desc,
      mainValue: yearlyHours.toStringAsFixed(1),
      mainUnit: S.current.yearly_report_play_time_unit,
      secondaryLabel: S.current.yearly_report_play_time_label,
      secondaryValue: S.current.yearly_report_play_time_value(totalHours.toStringAsFixed(1)),
    );
  }
}

class _CrashCountPage extends StatelessWidget {
  final YearlyReportData data;
  const _CrashCountPage({required this.data});
  @override
  Widget build(BuildContext context) => _AnimatedStatPage(
    icon: FontAwesomeIcons.bug,
    iconColor: Colors.orange,
    title: S.current.yearly_report_crash_title,
    description: S.current.yearly_report_crash_desc,
    mainValue: "${data.yearlyCrashCount}",
    mainUnit: S.current.about_analytics_units_times,
    secondaryLabel: S.current.yearly_report_crash_label,
    secondaryValue: S.current.yearly_report_launch_count_value(data.totalCrashCount),
    extraNote: data.yearlyCrashCount > 10
        ? S.current.yearly_report_crash_note_high
        : S.current.yearly_report_crash_note_low,
  );
}

class _SessionStatsPage extends StatelessWidget {
  final YearlyReportData data;
  const _SessionStatsPage({required this.data});
  @override
  Widget build(BuildContext context) {
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
              child: Text(
                S.current.yearly_report_session_title,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSessionCard(
                        context,
                        FontAwesomeIcons.chartLine,
                        Colors.blue,
                        S.current.yearly_report_session_average,
                        _formatDuration(data.averageSessionTime),
                        null,
                        null,
                      ),
                      const SizedBox(width: 12),
                      _buildSessionCard(
                        context,
                        FontAwesomeIcons.arrowUp,
                        Colors.green,
                        S.current.yearly_report_session_longest,
                        _formatDuration(data.longestSession),
                        Colors.green,
                        data.longestSessionDate,
                      ),
                      const SizedBox(width: 12),
                      _buildSessionCard(
                        context,
                        FontAwesomeIcons.arrowDown,
                        Colors.orange,
                        S.current.yearly_report_session_shortest,
                        _formatDuration(data.shortestSession),
                        Colors.orange,
                        data.shortestSessionDate,
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
                S.current.yearly_report_session_note,
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String label,
    String value,
    Color? valueColor,
    DateTime? date,
  ) {
    return Flexible(
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
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 8),
                Text(label, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor),
              textAlign: TextAlign.center,
            ),
            if (date != null)
              Text(
                S.current.yearly_report_session_date(date.month, date.day),
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
              ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyStatsPage extends StatelessWidget {
  final YearlyReportData data;
  const _MonthlyStatsPage({required this.data});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.calendarDays, size: 64, color: Colors.blue)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              S.current.yearly_report_monthly_title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (data.mostPlayedMonth != null)
                  _buildMonthCard(
                    context,
                    FontAwesomeIcons.fire,
                    Colors.orange,
                    S.current.yearly_report_monthly_most,
                    _getMonthName(data.mostPlayedMonth!),
                    Colors.orange,
                    S.current.yearly_report_monthly_most_count(data.mostPlayedMonthCount),
                  ),
                if (data.leastPlayedMonth != null && data.leastPlayedMonth != data.mostPlayedMonth)
                  _buildMonthCard(
                    context,
                    FontAwesomeIcons.snowflake,
                    Colors.teal,
                    S.current.yearly_report_monthly_least,
                    _getMonthName(data.leastPlayedMonth!),
                    Colors.teal,
                    S.current.yearly_report_monthly_least_count(data.leastPlayedMonthCount),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCard(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String label,
    String value,
    Color valueColor,
    String subLabel,
  ) {
    return Container(
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
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: valueColor),
          ),
          Text(subLabel, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .7))),
        ],
      ),
    );
  }
}

class _StreakStatsPage extends StatelessWidget {
  final YearlyReportData data;
  const _StreakStatsPage({required this.data});
  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return "";
    return S.current.yearly_report_date_range(start.month, start.day, end.month, end.day);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.fire, size: 64, color: Colors.red)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              S.current.yearly_report_streak_title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (data.longestPlayStreak > 0)
                  _buildStreakCard(
                    context,
                    FontAwesomeIcons.gamepad,
                    Colors.green,
                    S.current.yearly_report_streak_play,
                    data.longestPlayStreak,
                    Colors.green,
                    _formatDateRange(data.playStreakStartDate, data.playStreakEndDate),
                  ),
                if (data.longestOfflineStreak > 0)
                  _buildStreakCard(
                    context,
                    FontAwesomeIcons.bed,
                    Colors.grey,
                    S.current.yearly_report_streak_offline,
                    data.longestOfflineStreak,
                    Colors.grey,
                    _formatDateRange(data.offlineStreakStartDate, data.offlineStreakEndDate),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String label,
    int value,
    Color valueColor,
    String dateRange,
  ) {
    return Container(
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
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$value",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: valueColor),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 4),
                child: Text(S.current.yearly_report_streak_day_unit, style: TextStyle(fontSize: 18, color: valueColor)),
              ),
            ],
          ),
          if (dateRange.isNotEmpty)
            Text(dateRange, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6))),
        ],
      ),
    );
  }
}

class _KillDeathPage extends StatelessWidget {
  final YearlyReportData data;
  const _KillDeathPage({required this.data});
  @override
  Widget build(BuildContext context) {
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
            child: Text(S.current.yearly_report_kd_title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
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
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildKDCard(
                  context,
                  FontAwesomeIcons.skull,
                  Colors.green,
                  S.current.yearly_report_kd_kill,
                  data.yearlyKillCount,
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildKDCard(
                  context,
                  FontAwesomeIcons.skullCrossbones,
                  Colors.red,
                  S.current.yearly_report_kd_death,
                  data.yearlyDeathCount,
                  Colors.red,
                ),
                const SizedBox(width: 16),
                _buildKDCard(
                  context,
                  FontAwesomeIcons.personFalling,
                  Colors.orange,
                  S.current.yearly_report_kd_suicide,
                  data.yearlySelfKillCount,
                  Colors.orange,
                ),
              ],
            ),
          ),
          if (totalKD == 0)
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Text(
                S.current.yearly_report_kd_no_record,
                style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKDCard(BuildContext context, IconData icon, Color iconColor, String label, int value, Color valueColor) {
    return SizedBox(
      width: 100,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: FluentTheme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6))),
            const SizedBox(height: 4),
            Text(
              "$value",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarliestPlayPage extends StatelessWidget {
  final YearlyReportData data;
  const _EarliestPlayPage({required this.data});
  @override
  Widget build(BuildContext context) {
    final time = data.earliestPlayDate;
    final timeStr = time != null
        ? "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"
        : S.current.yearly_report_no_data;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.sun, size: 64, color: Colors.orange)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              S.current.yearly_report_earliest_play_title,
              style: TextStyle(fontSize: 24, color: Colors.white.withValues(alpha: .8)),
            ),
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
                S.current.yearly_report_earliest_play_desc(time.month, time.day),
                style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6)),
              ),
            ),
        ],
      ),
    );
  }
}

class _LatestPlayPage extends StatelessWidget {
  final YearlyReportData data;
  const _LatestPlayPage({required this.data});
  @override
  Widget build(BuildContext context) {
    final time = data.latestPlayDate;
    final timeStr = time != null
        ? "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"
        : S.current.yearly_report_no_data;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.moon, size: 64, color: Colors.purple)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              S.current.yearly_report_latest_play_title,
              style: TextStyle(fontSize: 24, color: Colors.white.withValues(alpha: .8)),
            ),
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
                S.current.yearly_report_latest_play_desc(time.month, time.day),
                style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6)),
              ),
            ),
        ],
      ),
    );
  }
}

class _VehicleDestructionPage extends StatelessWidget {
  final YearlyReportData data;
  const _VehicleDestructionPage({required this.data});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.explosion, size: 64, color: Colors.red)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              S.current.yearly_report_vehicle_destruction_title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Text(
              S.current.yearly_report_vehicle_destruction_desc,
              style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: .7)),
            ),
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
                  child: Text(S.current.yearly_report_vehicle_destruction_unit, style: TextStyle(fontSize: 24)),
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
                    Text(
                      S.current.yearly_report_vehicle_destruction_most,
                      style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9)),
                    ),
                    const SizedBox(height: 8),
                    Text(data.mostDestroyedVehicle!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                      S.current.yearly_report_vehicle_destruction_count(data.mostDestroyedVehicleCount),
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
}

class _VehiclePilotedPage extends HookWidget {
  final YearlyReportData data;
  const _VehiclePilotedPage({required this.data});
  @override
  Widget build(BuildContext context) {
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
              child: Text(
                S.current.yearly_report_vehicle_pilot_title,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
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
                      Text(
                        S.current.yearly_report_vehicle_pilot_most,
                        style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .9)),
                      ),
                      const SizedBox(height: 12),
                      Text(data.mostPilotedVehicle!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(
                        S.current.yearly_report_vehicle_pilot_count(data.mostPilotedVehicleCount),
                        style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .8)),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
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
                          Text(
                            showDetails.value
                                ? S.current.yearly_report_vehicle_pilot_collapse
                                : S.current.yearly_report_vehicle_pilot_expand(sortedVehicles.length),
                          ),
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
                          child: SingleChildScrollView(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: sortedVehicles
                                  .map(
                                    (v) => Container(
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
                                            v.key,
                                            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .9)),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "${v.value}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            S.current.about_analytics_units_times,
                                            style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .6)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
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
}

class _LocationStatsPage extends StatelessWidget {
  final YearlyReportData data;
  const _LocationStatsPage({required this.data});
  @override
  Widget build(BuildContext context) {
    if (data.topLocations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(child: Icon(FontAwesomeIcons.locationDot, size: 64, color: Colors.grey)),
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Text(
                S.current.yearly_report_location_title,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Text(
                S.current.yearly_report_location_no_record,
                style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6)),
              ),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.locationDot, size: 64, color: Colors.red)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              S.current.yearly_report_location_frequent,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Text(
              S.current.yearly_report_location_note,
              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6)),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: data.topLocations.take(10).toList().asMap().entries.map((e) {
                    final idx = e.key;
                    final loc = e.value;
                    final isTop3 = idx < 3;
                    return Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isTop3
                            ? FluentTheme.of(context).accentColor.withValues(alpha: .2 - idx * 0.05)
                            : FluentTheme.of(context).cardColor.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: isTop3 ? Colors.yellow.withValues(alpha: 1 - idx * 0.3) : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${idx + 1}",
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
                                  loc.key,
                                  style: TextStyle(fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  S.current.yearly_report_launch_count_value(loc.value),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountStatsPage extends HookWidget {
  final YearlyReportData data;
  const _AccountStatsPage({required this.data});
  @override
  Widget build(BuildContext context) {
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
            child: Text(
              S.current.yearly_report_account_title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
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
                    Text(
                      S.current.yearly_report_account_most,
                      style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .9)),
                    ),
                    const SizedBox(height: 12),
                    Text(data.mostPlayedAccount!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(
                      S.current.yearly_report_account_count(data.mostPlayedAccountSessionCount),
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
              S.current.yearly_report_account_total(data.accountCount),
              style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .5)),
            ),
          ),
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
                        Text(
                          showDetails.value
                              ? S.current.yearly_report_vehicle_pilot_collapse
                              : S.current.yearly_report_account_expand,
                        ),
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
                        child: SingleChildScrollView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: sortedAccounts
                                .map(
                                  (a) => Container(
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
                                          a.key,
                                          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .9)),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "${a.value}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          S.current.about_analytics_units_times,
                                          style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .6)),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
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
}

class _SummaryPage extends StatelessWidget {
  final int year;
  const _SummaryPage({required this.year});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(child: Icon(FontAwesomeIcons.trophy, size: 80, color: Colors.yellow)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Text(
              S.current.yearly_report_thanks_title,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: Text(
              S.current.yearly_report_thanks_message(year.toString()),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: .8)),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 700),
            child: Text(
              S.current.yearly_report_thanks_next((year + 1).toString()),
              style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .6)),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 900),
            child: Button(
              onPressed: () {
                launchUrlString("https://github.com/StarCitizenToolBox/app");
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(FontAwesomeIcons.github),
                    const SizedBox(width: 12),
                    Text(S.current.support_dev_github_star_button),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataSummaryPage extends StatelessWidget {
  final YearlyReportData data;
  final int year;
  const _DataSummaryPage({required this.data, required this.year});
  @override
  Widget build(BuildContext context) {
    final yearlyHours = data.yearlyPlayTime.inMinutes / 60;
    final dataItems = <_SummaryGridItem>[
      _SummaryGridItem(
        S.current.yearly_report_summary_launch_game,
        "${data.yearlyLaunchCount}",
        S.current.about_analytics_units_times,
        FontAwesomeIcons.play,
        Colors.green,
      ),
      _SummaryGridItem(
        S.current.yearly_report_play_time_title,
        yearlyHours.toStringAsFixed(1),
        S.current.yearly_report_play_time_unit,
        FontAwesomeIcons.clock,
        Colors.blue,
      ),
      _SummaryGridItem(
        S.current.yearly_report_crash_title,
        "${data.yearlyCrashCount}",
        S.current.about_analytics_units_times,
        FontAwesomeIcons.bug,
        Colors.orange,
      ),
      _SummaryGridItem(
        S.current.yearly_report_kd_kill,
        "${data.yearlyKillCount}",
        S.current.about_analytics_units_times,
        FontAwesomeIcons.crosshairs,
        Colors.green,
      ),
      _SummaryGridItem(
        S.current.yearly_report_kd_death,
        "${data.yearlyDeathCount}",
        S.current.about_analytics_units_times,
        FontAwesomeIcons.skull,
        Colors.red,
      ),
      _SummaryGridItem(
        S.current.yearly_report_vehicle_destruction_title,
        "${data.yearlyVehicleDestructionCount}",
        S.current.about_analytics_units_times,
        FontAwesomeIcons.explosion,
        Colors.red,
      ),
      if (data.longestSession != null)
        _SummaryGridItem(
          S.current.yearly_report_summary_longest_online,
          (data.longestSession!.inMinutes / 60).toStringAsFixed(1),
          S.current.yearly_report_play_time_unit,
          FontAwesomeIcons.hourglassHalf,
          Colors.purple,
        ),
      if (data.earliestPlayDate != null)
        _SummaryGridItem(
          S.current.yearly_report_summary_earliest_time,
          "${data.earliestPlayDate!.hour.toString().padLeft(2, '0')}:${data.earliestPlayDate!.minute.toString().padLeft(2, '0')}",
          "",
          FontAwesomeIcons.sun,
          Colors.orange,
        ),
      if (data.latestPlayDate != null)
        _SummaryGridItem(
          S.current.yearly_report_summary_latest_time,
          "${data.latestPlayDate!.hour.toString().padLeft(2, '0')}:${data.latestPlayDate!.minute.toString().padLeft(2, '0')}",
          "",
          FontAwesomeIcons.moon,
          Colors.purple,
        ),
      _SummaryGridItem(
        S.current.yearly_report_summary_respawn_count,
        "${data.yearlySelfKillCount}",
        S.current.about_analytics_units_times,
        FontAwesomeIcons.personFalling,
        Colors.grey,
      ),
      if (data.mostPlayedMonth != null)
        _SummaryGridItem(
          S.current.yearly_report_summary_hottest_month,
          _getMonthName(data.mostPlayedMonth!),
          "",
          FontAwesomeIcons.fire,
          Colors.orange,
        ),
      if (data.longestPlayStreak > 0)
        _SummaryGridItem(
          S.current.yearly_report_streak_play,
          "${data.longestPlayStreak}",
          S.current.yearly_report_streak_day_unit,
          FontAwesomeIcons.gamepad,
          Colors.green,
        ),
      if (data.longestOfflineStreak > 0)
        _SummaryGridItem(
          S.current.yearly_report_streak_offline,
          "${data.longestOfflineStreak}",
          S.current.yearly_report_streak_day_unit,
          FontAwesomeIcons.bed,
          Colors.grey,
        ),
      if (data.topLocations.isNotEmpty)
        _SummaryGridItem(
          S.current.yearly_report_summary_frequent_location,
          data.topLocations.first.key,
          "",
          FontAwesomeIcons.locationDot,
          Colors.red,
          isWide: true,
        ),
      if (data.mostPilotedVehicle != null)
        _SummaryGridItem(
          S.current.yearly_report_summary_favorite_vehicle,
          data.mostPilotedVehicle!,
          "",
          FontAwesomeIcons.shuttleSpace,
          Colors.teal,
          isWide: true,
        ),
    ];
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          children: [
            FadeInDown(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.star, size: 20, color: Colors.yellow),
                  const SizedBox(width: 12),
                  Text(
                    S.current.yearly_report_title(year.toString()),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Icon(FontAwesomeIcons.star, size: 20, color: Colors.yellow),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (data.mostPlayedAccount != null)
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  data.mostPlayedAccount!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            const SizedBox(height: 20),
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
                  itemBuilder: (ctx, idx) {
                    final item = dataItems[idx];
                    final isSmallFont = item.isWide;
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
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Text(
                S.current.yearly_report_powered_by,
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .3)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
