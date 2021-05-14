part of 'stickers_bloc.dart';

class StickersState extends Equatable {
  const StickersState({
    this.isDrawerActive = false,
    this.shouldDisplayPropsReminder = true,
    this.tabIndex = 0,
  });

  final bool isDrawerActive;
  final bool shouldDisplayPropsReminder;
  final int tabIndex;

  @override
  List<Object> get props => [
        isDrawerActive,
        shouldDisplayPropsReminder,
        tabIndex,
      ];

  StickersState copyWith({
    bool? isDrawerActive,
    bool? shouldDisplayPropsReminder,
    int? tabIndex,
  }) {
    return StickersState(
      isDrawerActive: isDrawerActive ?? this.isDrawerActive,
      shouldDisplayPropsReminder:
          shouldDisplayPropsReminder ?? this.shouldDisplayPropsReminder,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}
