import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';

enum BindingChipStyle { none, byDefault, custom, cleared, conflict }

/// Conflict marker color: yellow (fluent's warningPrimaryColor is orange-red).
const kbConflictColor = Color(0xFFE3B341);

/// One color per modifier, so combos read at a glance (several modifiers → striped flag).
const _modifierColors = <String, Color>{
  'lalt': Color(0xFFA371F7),
  'ralt': Color(0xFFF2CC60),
  'lctrl': Color(0xFFF0883E),
  'rctrl': Color(0xFFF85149),
  'lshift': Color(0xFF3FB950),
  'rshift': Color(0xFF39C5CF),
  'shoulderl': Color(0xFFE3B341),
};

Color modifierColor(String modifier) => _modifierColors[modifier] ?? const Color(0xFF8B949E);

/// Horizontal stripes, one per modifier, like a pride flag.
class ModifierFlag extends StatelessWidget {
  const ModifierFlag({
    super.key,
    required this.modifiers,
    this.width = 14,
    this.height = 12,
    this.alpha = 1,
    this.baseColor,
  });

  final List<String> modifiers;

  /// "All" view: the key also works on its own; this stripe (the accent) comes first.
  final Color? baseColor;
  final double width;
  final double height;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            if (baseColor != null)
              Expanded(
                child: Container(color: baseColor!.withValues(alpha: alpha)),
              ),
            for (final m in modifiers)
              Expanded(
                child: Container(color: modifierColor(m).withValues(alpha: alpha)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Which color stands for which modifier.
class ModifierLegend extends StatelessWidget {
  const ModifierLegend({super.key, required this.modifiers, required this.labelOf});

  final List<String> modifiers;
  final String Function(String) labelOf;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        for (final m in modifiers)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ModifierFlag(modifiers: [m], width: 12, height: 12),
              const SizedBox(width: 5),
              Text(labelOf(m), style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .7))),
            ],
          ),
      ],
    );
  }
}

BindingChipStyle bindingChipStyleOf(ScSlot slot, {bool conflict = false}) {
  if (conflict && slot.input != null) return BindingChipStyle.conflict;
  return switch (slot.state) {
    ScSlotState.none => BindingChipStyle.none,
    ScSlotState.byDefault => slot.hasModeOverride ? BindingChipStyle.custom : BindingChipStyle.byDefault,
    ScSlotState.custom => BindingChipStyle.custom,
    ScSlotState.cleared => BindingChipStyle.cleared,
  };
}

/// Key-cap style label for one binding. Same radius (4) as the app's buttons; colors come from
/// the theme's accent and warning colors so it tracks theme changes.
class BindingChip extends StatelessWidget {
  const BindingChip({super.key, required this.text, required this.style, this.fontSize = 12});

  final String text;
  final BindingChipStyle style;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final accent = theme.accentColor;
    const warning = kbConflictColor;
    if (style == BindingChipStyle.none) {
      return Text(
        '—',
        style: TextStyle(fontSize: fontSize, color: Colors.white.withValues(alpha: .3)),
      );
    }
    final (Color? bg, Color border, Color fg) = switch (style) {
      BindingChipStyle.byDefault => (
        Colors.white.withValues(alpha: .07),
        Colors.white.withValues(alpha: .14),
        Colors.white.withValues(alpha: .9),
      ),
      BindingChipStyle.custom => (accent.withValues(alpha: .16), accent.withValues(alpha: .55), accent.lightest),
      BindingChipStyle.cleared => (null, Colors.white.withValues(alpha: .24), Colors.white.withValues(alpha: .5)),
      // Many flagged overlaps are harmless (different modes), so keep it low-key: blue with a yellow edge.
      BindingChipStyle.conflict => (accent.withValues(alpha: .16), warning.withValues(alpha: .8), accent.lightest),
      BindingChipStyle.none => (null, Colors.transparent, Colors.transparent),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          color: fg,
          decoration: style == BindingChipStyle.cleared ? TextDecoration.lineThrough : null,
          decorationColor: fg,
        ),
      ),
    );
  }
}
