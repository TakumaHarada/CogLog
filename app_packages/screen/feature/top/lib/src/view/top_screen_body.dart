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

  /// 指標ボタン、3 期間、撮影導線を並べる。
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
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final metric in PeriodTotalMetric.values)
                FButton(
                  variant: entity.metric == metric
                      ? FButtonVariant.primary
                      : FButtonVariant.outline,
                  onPress: () {
                    ref
                        .read(TopScreenViewModel.provider)
                        .onSelectMetric(metric);
                  },
                  child: Text(_metricLabel(metric)),
                ),
            ],
          ),
          _PeriodRow(
            label: strings.screen_feature_top_today,
            value: entity.todayText,
            metric: entity.metric,
          ),
          _PeriodRow(
            label: strings.screen_feature_top_this_week,
            value: entity.weekText,
            metric: entity.metric,
          ),
          _PeriodRow(
            label: strings.screen_feature_top_this_month,
            value: entity.monthText,
            metric: entity.metric,
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

class _PeriodRow extends StatelessWidget {
  const _PeriodRow({
    required this.label,
    required this.value,
    required this.metric,
  });

  final String label;
  final String value;
  final PeriodTotalMetric metric;

  @override
  Widget build(BuildContext context) {
    final unit = _unit(metric);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(unit == null ? value : '$value $unit'),
        ],
      ),
    );
  }
}
