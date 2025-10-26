import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GridItemAnimator extends HookWidget {
  final Widget child; // 要添加动画效果的子组件
  final int index; // 条目在网格中的索引位置
  final Duration duration; // 动画持续时间
  final Duration delayPerItem; // 每个条目之间的延迟时间
  final double slideOffset; // 上移的偏移量（像素）

  const GridItemAnimator({
    super.key,
    required this.child,
    required this.index,
    this.duration = const Duration(milliseconds: 230),
    this.delayPerItem = const Duration(milliseconds: 50),
    this.slideOffset = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    // 创建动画控制器
    final animationController = useAnimationController(duration: duration);

    // 创建不透明度动画
    final opacityAnimation = useAnimation(
      Tween<double>(
        begin: 0.0, // 开始时完全透明
        end: 1.0, // 结束时完全不透明
      ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut)),
    );

    // 创建位移动画
    final slideAnimation = useAnimation(
      Tween<double>(
        begin: 1.0, // 开始位置
        end: 0.0, // 结束位置
      ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic)),
    );

    // 组件挂载后启动动画
    useEffect(() {
      // 根据索引计算延迟时间，实现逐个条目入场
      final delay = delayPerItem * index;
      bool cancelled = false;

      Future.delayed(delay, () {
        if (!cancelled && animationController.status != AnimationStatus.completed) {
          animationController.forward();
        }
      });

      return () {
        cancelled = true;
      };
    }, const []);

    // 应用动画效果
    return Opacity(
      opacity: opacityAnimation,
      child: Transform.translate(
        offset: Offset(0, slideOffset * slideAnimation), // 向上平移动画
        child: child,
      ),
    );
  }
}
