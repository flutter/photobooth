part of 'stickers_bloc.dart';

class StickersState extends Equatable {
  const StickersState({
    this.isDrawerActive = false,
    this.shouldDisplayPropsReminder = true,
    this.tabSelected = 0,
  });

  final bool isDrawerActive;
  final bool shouldDisplayPropsReminder;
  final int tabSelected;

  @override
  List<Object> get props => [
        isDrawerActive,
        shouldDisplayPropsReminder,
        tabSelected,
      ];

  StickersState copyWith({
    bool? isDrawerActive,
    bool? shouldDisplayPropsReminder,
    int? tabSelected,
  }) {
    return StickersState(
      isDrawerActive: isDrawerActive ?? this.isDrawerActive,
      shouldDisplayPropsReminder:
          shouldDisplayPropsReminder ?? this.shouldDisplayPropsReminder,
      tabSelected: tabSelected ?? this.tabSelected,
    );
  }
}
