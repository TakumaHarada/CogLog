import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:meta/meta.dart';

import '../strings.dart';
import '../viewmodel/goal_settings_screen_view_model.dart';
import 'goal_settings_screen_providers.dart';

/// 運動時間・カロリー・距離の入力と保存。
///
/// Example:
/// ```dart
/// const GoalSettingsScreenBody();
/// ```
@internal
class GoalSettingsScreenBody extends HookConsumerWidget {
  /// 本文を作る。
  ///
  /// Example:
  /// ```dart
  /// const GoalSettingsScreenBody();
  /// ```
  const GoalSettingsScreenBody({super.key});

  /// 各欄の controller を Entity と同期し、保存ボタンで [onSave] する。
  ///
  /// Example:
  /// ```dart
  /// const GoalSettingsScreenBody();
  /// ```
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(GoalSettingsScreenProviders.entity);
    final hoursController = useTextEditingController();
    final minutesController = useTextEditingController();
    final secondsController = useTextEditingController();
    final caloriesController = useTextEditingController();
    final distanceController = useTextEditingController();
    final saving = useState(false);

    useEffect(
      () {
        if (!entity.loaded) {
          return null;
        }
        hoursController.text = entity.hours;
        minutesController.text = entity.minutes;
        secondsController.text = entity.seconds;
        caloriesController.text = entity.calories;
        distanceController.text = entity.distance;
        return null;
      },
      [
        entity.loaded,
        entity.hours,
        entity.minutes,
        entity.seconds,
        entity.calories,
        entity.distance,
      ],
    );

    return FScaffold(
      header: FHeader(title: Text(strings.screen_feature_goal_settings_title)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Text(strings.screen_feature_goal_settings_duration_label),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: FTextField(
                    control: .managed(controller: hoursController),
                    label: Text(
                      strings.screen_feature_goal_settings_hours_label,
                    ),
                    keyboardType: TextInputType.number,
                    enabled: entity.loaded && !saving.value,
                  ),
                ),
                Expanded(
                  child: FTextField(
                    control: .managed(controller: minutesController),
                    label: Text(
                      strings.screen_feature_goal_settings_minutes_label,
                    ),
                    keyboardType: TextInputType.number,
                    enabled: entity.loaded && !saving.value,
                  ),
                ),
                Expanded(
                  child: FTextField(
                    control: .managed(controller: secondsController),
                    label: Text(
                      strings.screen_feature_goal_settings_seconds_label,
                    ),
                    keyboardType: TextInputType.number,
                    enabled: entity.loaded && !saving.value,
                  ),
                ),
              ],
            ),
            FTextField(
              control: .managed(controller: caloriesController),
              label: Text(strings.screen_feature_goal_settings_calories_label),
              description: Text(
                strings.screen_feature_goal_settings_calories_unit,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              enabled: entity.loaded && !saving.value,
            ),
            FTextField(
              control: .managed(controller: distanceController),
              label: Text(strings.screen_feature_goal_settings_distance_label),
              description: Text(
                strings.screen_feature_goal_settings_distance_unit,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              enabled: entity.loaded && !saving.value,
            ),
            Text(
              strings.screen_feature_goal_settings_unset_hint,
              style: context.theme.typography.body.sm.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
            FButton(
              onPress: !entity.loaded || saving.value
                  ? null
                  : () async {
                      saving.value = true;
                      try {
                        await ref
                            .read(GoalSettingsScreenViewModel.provider)
                            .onSave(
                              hours: hoursController.text,
                              minutes: minutesController.text,
                              seconds: secondsController.text,
                              calories: caloriesController.text,
                              distance: distanceController.text,
                            );
                      } on Object {
                        // 永続化失敗を画面クラッシュにしない。パース拒否とは別。
                      } finally {
                        saving.value = false;
                      }
                    },
              child: Text(strings.screen_feature_goal_settings_save),
            ),
          ],
        ),
      ),
    );
  }
}
