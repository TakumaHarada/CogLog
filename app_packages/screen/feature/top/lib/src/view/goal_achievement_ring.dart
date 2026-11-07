import 'dart:math' as math;

import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:meta/meta.dart';

/// 目標達成率の円グラフ。第 1 周と第 2 周を重ねて描く。
///
/// [lap1] / [lap2] はそれぞれ 0〜1。[percentText] は実達成率の表記。
///
/// Example:
/// ```dart
/// GoalAchievementRing(
///   title: '消費カロリー',
///   lap1: 1,
///   lap2: 0.5,
///   percentText: '150%',
///   actualText: '300.0',
///   goalText: '200.0',
///   actualLabel: '実績',
///   goalLabel: '目標',
/// );
/// ```
@internal
class GoalAchievementRing extends StatelessWidget {
  /// 指標名と二周の割合、実績・目標の表記を持つ。
  ///
  /// Example:
  /// ```dart
  /// GoalAchievementRing(
  ///   title: '運動時間',
  ///   lap1: 1,
  ///   lap2: 0,
  ///   percentText: '100%',
  ///   actualText: '0h30m',
  ///   goalText: '0h30m',
  ///   actualLabel: '実績',
  ///   goalLabel: '目標',
  /// );
  /// ```
  const GoalAchievementRing({
    required this.title,
    required this.lap1,
    required this.lap2,
    required this.percentText,
    required this.actualText,
    required this.goalText,
    required this.actualLabel,
    required this.goalLabel,
    this.unsetPrompt,
    super.key,
  });

  /// 指標名。
  final String title;

  /// 第 1 周の塗り割合（0〜1）。
  final double lap1;

  /// 第 2 周の塗り割合（0〜1）。
  final double lap2;

  /// 中央に出す達成率（例: `150%`）。未設定時は空。
  final String percentText;

  /// 実績の数値表記。
  final String actualText;

  /// 目標の数値表記。
  final String goalText;

  /// 実績のラベル。
  final String actualLabel;

  /// 目標のラベル。
  final String goalLabel;

  /// 未設定のときの設定促進文言。非 null ならリングの代わりに出す。
  final String? unsetPrompt;

  /// 見出し・円・実績/目標を縦に並べる。
  ///
  /// Example:
  /// ```dart
  /// GoalAchievementRing(
  ///   title: '走行距離',
  ///   lap1: 1,
  ///   lap2: 1,
  ///   percentText: '250%',
  ///   actualText: '12.5',
  ///   goalText: '5.0',
  ///   actualLabel: '実績',
  ///   goalLabel: '目標',
  /// );
  /// ```
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final titleStyle = theme.typography.body.sm.copyWith(
      fontWeight: FontWeight.w600,
    );
    final muted = theme.typography.body.xs.copyWith(
      color: theme.colors.mutedForeground,
    );
    final prompt = unsetPrompt;
    final clampedLap1 = lap1.clamp(0.0, 1.0).toDouble();
    final clampedLap2 = lap2.clamp(0.0, 1.0).toDouble();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: titleStyle, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        if (prompt != null)
          SizedBox(
            height: 96,
            child: Center(
              child: Text(prompt, style: muted, textAlign: TextAlign.center),
            ),
          )
        else ...[
          SizedBox(
            width: 96,
            height: 96,
            child: CustomPaint(
              painter: _GoalAchievementRingPainter(
                lap1: clampedLap1,
                lap2: clampedLap2,
                trackColor: theme.colors.secondary,
                lap1Color: theme.colors.primary,
                lap2Color: theme.colors.mutedForeground,
              ),
              child: Center(
                child: Text(
                  percentText,
                  style: theme.typography.body.sm.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$actualLabel $actualText',
            style: muted,
            textAlign: TextAlign.center,
          ),
          Text(
            '$goalLabel $goalText',
            style: muted,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// [lap1] を内側、[lap2] を外側の弧として描く。
final class _GoalAchievementRingPainter extends CustomPainter {
  /// 二周分の色と割合を持つ。
  ///
  /// Example:
  /// ```dart
  /// const _GoalAchievementRingPainter(
  ///   lap1: 1,
  ///   lap2: 0.5,
  ///   trackColor: Colors.grey,
  ///   lap1Color: Colors.blue,
  ///   lap2Color: Colors.black,
  /// );
  /// ```
  const _GoalAchievementRingPainter({
    required this.lap1,
    required this.lap2,
    required this.trackColor,
    required this.lap1Color,
    required this.lap2Color,
  });

  /// 第 1 周（0〜1）。
  final double lap1;

  /// 第 2 周（0〜1）。
  final double lap2;

  /// 未塗りの軌道色。
  final Color trackColor;

  /// 第 1 周の色。
  final Color lap1Color;

  /// 第 2 周の色。
  final Color lap2Color;

  /// 軌道、第 1 周（内側）、第 2 周（外側）の順に描く。
  ///
  /// Example:
  /// ```dart
  /// CustomPaint(painter: painter);
  /// ```
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final stroke = size.shortestSide * 0.1;
    final gap = stroke * 0.35;
    final outerRadius = (size.shortestSide - stroke) / 2;
    final innerRadius = outerRadius - stroke - gap;
    const start = -math.pi / 2;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;
    canvas.drawCircle(center, innerRadius, track);
    canvas.drawCircle(center, outerRadius, track);

    if (lap1 > 0) {
      final paint = Paint()
        ..color = lap1Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        start,
        lap1 * 2 * math.pi,
        false,
        paint,
      );
    }
    if (lap2 > 0) {
      final paint = Paint()
        ..color = lap2Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        start,
        lap2 * 2 * math.pi,
        false,
        paint,
      );
    }
  }

  /// 割合または色が変わったときだけ再描画する。
  ///
  /// Example:
  /// ```dart
  /// painter.shouldRepaint(oldPainter);
  /// ```
  @override
  bool shouldRepaint(covariant _GoalAchievementRingPainter oldDelegate) =>
      lap1 != oldDelegate.lap1 ||
      lap2 != oldDelegate.lap2 ||
      trackColor != oldDelegate.trackColor ||
      lap1Color != oldDelegate.lap1Color ||
      lap2Color != oldDelegate.lap2Color;
}
