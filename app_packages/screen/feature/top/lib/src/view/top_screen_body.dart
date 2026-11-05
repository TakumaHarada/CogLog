import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:forui/forui.dart';
import 'package:foundation_resources/gen/strings.dart' as foundation_resources;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:meta/meta.dart';
import 'package:screen_navigation/screen_navigation.dart';

import '../../gen/strings.dart';
import '../viewmodel/top_screen_view_model.dart';
import 'top_screen_providers.dart';

/// この画面と共通リソースの文言。
final class _Strings
    with L10nStringsMixin, foundation_resources.L10nStringsMixin {
  /// 生成 mixin を束ねる。
  const _Strings();
}

/// 画面から参照する文言。
///
/// Example:
/// ```dart
/// strings.screen_feature_top_today;
/// ```
@internal
final strings = _Strings();

/// 期間の合計と指標の切り替え。
@internal
class TopScreenBody extends HookConsumerWidget {
  /// 本文を作る。
  ///
  /// Example:
  /// ```dart
  /// const TopScreenBody();
  /// ```
  const TopScreenBody({super.key});

  /// 指標の Select を上に、3 期間のボックスを横に並べる。
  ///
  /// Example:
  /// ```dart
  /// const TopScreenBody();
  /// ```
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(TopScreenProviders.entity);
    return FScaffold(
      header: FHeader(
        title: Text(strings.foundation_resources_app_name),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FLucideIcons.camera),
            semanticsLabel: strings.screen_feature_top_open_camera,
            onPress: () async {
              await ref.read(screenNavigationProvider).openMeterPanelCamera();
              await ref.read(TopScreenViewModel.provider).onInitialize();
            },
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          FSelect<PeriodTotalMetric>(
            control: .lifted(
              value: entity.metric,
              onChange: (metric) {
                if (metric == null || metric == entity.metric) {
                  return;
                }
                ref.read(TopScreenViewModel.provider).onSelectMetric(metric);
              },
            ),
            items: {
              for (final metric in PeriodTotalMetric.values)
                _metricLabel(metric): metric,
            },
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: _PeriodBox(
                  label: strings.screen_feature_top_today,
                  value: entity.todayText,
                  metric: entity.metric,
                ),
              ),
              Expanded(
                child: _PeriodBox(
                  label: strings.screen_feature_top_this_week,
                  value: entity.weekText,
                  metric: entity.metric,
                ),
              ),
              Expanded(
                child: _PeriodBox(
                  label: strings.screen_feature_top_this_month,
                  value: entity.monthText,
                  metric: entity.metric,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _metricLabel(PeriodTotalMetric metric) => switch (metric) {
  PeriodTotalMetric.distance => strings.screen_feature_top_distance,
  PeriodTotalMetric.calories => strings.screen_feature_top_calories,
  PeriodTotalMetric.duration => strings.screen_feature_top_duration,
};

String? _unit(PeriodTotalMetric metric) => switch (metric) {
  PeriodTotalMetric.distance => strings.screen_feature_top_distance_unit,
  PeriodTotalMetric.calories => strings.screen_feature_top_calories_unit,
  PeriodTotalMetric.duration => null,
};

class _PeriodBox extends StatelessWidget {
  const _PeriodBox({
    required this.label,
    required this.value,
    required this.metric,
  });

  final String label;
  final String value;
  final PeriodTotalMetric metric;

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.theme.typography.body.xs.copyWith(
      color: context.theme.colors.mutedForeground,
    );
    return FCard(
      child: SizedBox(
        height: 148,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: labelStyle),
              Expanded(
                child: Center(
                  child: _HeroValue(value: value, metric: metric),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroValue extends StatelessWidget {
  const _HeroValue({required this.value, required this.metric});

  final String value;
  final PeriodTotalMetric metric;

  @override
  Widget build(BuildContext context) {
    final numberStyle = context.theme.typography.display.md.copyWith(
      fontSize: 32,
      height: 1.1,
      fontWeight: FontWeight.w700,
    );
    final unitStyle = context.theme.typography.body.sm.copyWith(
      color: context.theme.colors.mutedForeground,
    );
    final duration = RegExp(r'^(\d+)h(\d+)m$').firstMatch(value);
    if (duration != null) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: duration.group(1), style: numberStyle),
              TextSpan(text: 'h', style: unitStyle),
              TextSpan(text: duration.group(2), style: numberStyle),
              TextSpan(text: 'm', style: unitStyle),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    final unit = _unit(metric);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: numberStyle, textAlign: TextAlign.center),
          if (unit != null) Text(unit, style: unitStyle),
        ],
      ),
    );
  }
}
