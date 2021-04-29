part of 'stickers_bloc.dart';

class StickersState extends Equatable {
  const StickersState({
    this.isDrawerActive = false,
    this.displayClearStickersTooltip = true,
  });

  final bool isDrawerActive;
  final bool displayClearStickersTooltip;

  @override
  List<Object> get props => [isDrawerActive, displayClearStickersTooltip];

  StickersState copyWith({
    bool? isDrawerActive,
    bool? displayClearStickersTooltip,
  }) {
    return StickersState(
      isDrawerActive: isDrawerActive ?? this.isDrawerActive,
      displayClearStickersTooltip:
          displayClearStickersTooltip ?? this.displayClearStickersTooltip,
    );
  }
}
