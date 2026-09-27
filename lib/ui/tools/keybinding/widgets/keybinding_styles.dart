import 'package:fluent_ui/fluent_ui.dart';

/// Visual styles from the approved keybinding prototype, applied to native fluent_ui buttons.
/// Radius 4 and the translucent fills match the app's existing buttons and cards.

const _radius = BorderRadius.all(Radius.circular(4));

ButtonStyle _outlined({required Color fill, required Color hoverFill, required Color border, required Color fg}) =>
    ButtonStyle(
      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
      backgroundColor: WidgetStateProperty.resolveWith((s) {
        if (s.isDisabled) return Colors.transparent;
        return s.isHovered || s.isPressed ? hoverFill : fill;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((s) => s.isDisabled ? Colors.white.withValues(alpha: .3) : fg),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: _radius,
          side: BorderSide(color: border),
        ),
      ),
    );

/// Record button: translucent accent fill + accent outline.
ButtonStyle kbRecordButtonStyle(BuildContext context) {
  final accent = FluentTheme.of(context).accentColor;
  return _outlined(
    fill: accent.withValues(alpha: .12),
    hoverFill: accent.withValues(alpha: .22),
    border: accent.withValues(alpha: .45),
    fg: const Color(0xFFCFE9FF),
  );
}

/// Secondary actions next to it (clear / reset): transparent with a faint outline.
ButtonStyle kbGhostButtonStyle(BuildContext context) => _outlined(
  fill: Colors.transparent,
  hoverFill: Colors.white.withValues(alpha: .06),
  border: Colors.white.withValues(alpha: .12),
  fg: Colors.white,
);

/// Toolbar toggles: unchecked like a normal button, checked with a translucent tint and outline.
ToggleButtonThemeData kbToggleStyle(BuildContext context, {Color? tint}) {
  final c = tint ?? FluentTheme.of(context).accentColor;
  final unchecked = _outlined(
    fill: Colors.white.withValues(alpha: .05),
    hoverFill: Colors.white.withValues(alpha: .09),
    border: Colors.white.withValues(alpha: .08),
    fg: Colors.white,
  );
  return ToggleButtonThemeData(
    checkedButtonStyle: _outlined(
      fill: c.withValues(alpha: .18),
      hoverFill: c.withValues(alpha: .26),
      border: c.withValues(alpha: .6),
      fg: Colors.white,
    ),
    uncheckedButtonStyle: unchecked,
  );
}

class KbRecordDot extends StatelessWidget {
  const KbRecordDot({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: const BoxDecoration(color: Color(0xFFFF6B6B), shape: BoxShape.circle),
  );
}

/// Segmented selector: one framed group, the selected segment tinted with the accent.
class KbSegmented<T> extends StatelessWidget {
  const KbSegmented({super.key, required this.value, required this.items, required this.onChanged});

  final T value;
  final List<(T, String)> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final accent = FluentTheme.of(context).accentColor;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (v, label) in items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Button(
                onPressed: () => onChanged(v),
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
                  backgroundColor: WidgetStateProperty.resolveWith((s) {
                    if (v == value) return accent.withValues(alpha: .22);
                    return s.isHovered ? Colors.white.withValues(alpha: .06) : Colors.transparent;
                  }),
                  foregroundColor: WidgetStatePropertyAll(
                    v == value ? const Color(0xFFCFE9FF) : Colors.white.withValues(alpha: .72),
                  ),
                  shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: _radius)),
                ),
                child: Text(label),
              ),
            ),
        ],
      ),
    );
  }
}
