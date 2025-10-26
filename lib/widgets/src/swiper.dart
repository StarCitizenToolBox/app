import 'package:card_swiper/card_swiper.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

class HoverSwiper extends HookWidget {
  const HoverSwiper({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.autoplayDelay = 3000,
    this.paginationActiveSize = 8.0,
    this.controlSize = 24,
    this.controlPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double paginationActiveSize;
  final double controlSize;
  final EdgeInsets controlPadding;
  final int autoplayDelay;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final controller = useMemoized(() => SwiperController());

    useEffect(() {
      return controller.dispose;
    }, [controller]);

    return MouseRegion(
      onEnter: (_) {
        isHovered.value = true;
        controller.stopAutoplay();
      },
      onExit: (_) {
        isHovered.value = false;
        controller.startAutoplay();
      },
      child: Stack(
        children: [
          Tilt(
            shadowConfig: const ShadowConfig(maxIntensity: .3),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Swiper(
              controller: controller,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              autoplay: true,
              autoplayDelay: autoplayDelay,
            ),
          ),
          // Left control button
          _buildControlButton(
            isHovered: isHovered.value,
            position: 'left',
            onTap: () => controller.previous(),
            icon: FluentIcons.chevron_left,
          ),
          // Right control button
          _buildControlButton(
            isHovered: isHovered.value,
            position: 'right',
            onTap: () => controller.next(),
            icon: FluentIcons.chevron_right,
          ),
        ],
      ),
    );
  }

  /// 构建控制按钮（左/右箭头）
  Widget _buildControlButton({
    required bool isHovered,
    required String position,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final isLeft = position == 'left';
    return Positioned(
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      top: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: isHovered ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: IgnorePointer(
          ignoring: !isHovered,
          child: Center(
            child: Padding(
              padding: controlPadding,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(icon, size: controlSize, color: Colors.white.withValues(alpha: .8)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
