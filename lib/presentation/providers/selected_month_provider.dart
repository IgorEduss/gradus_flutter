import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_month_provider.g.dart';

@riverpod
class SelectedMonth extends _$SelectedMonth {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void setMonth(DateTime date) {
    state = date;
  }

  void nextMonth() {
    state = DateTime(state.year, state.month + 1, state.day);
  }

  void previousMonth() {
    state = DateTime(state.year, state.month - 1, state.day);
  }
}
