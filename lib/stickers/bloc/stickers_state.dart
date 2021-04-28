part of 'stickers_bloc.dart';

class StickersState extends Equatable {
  const StickersState({
    this.isDrawerActive = false,
    this.displayOpenStickersTooltip = true,
    this.displayClearStickersTooltip = true,
  });

  final bool isDrawerActive;
  final bool displayOpenStickersTooltip;
  final bool displayClearStickersTooltip;

  @override
  List<Object> get props =>
      [isDrawerActive, displayOpenStickersTooltip, displayClearStickersTooltip];

  StickersState copyWith({
    bool? isDrawerActive,
    bool? displayOpenStickersTooltip,
    bool? displayClearStickersTooltip,
  }) {
    return StickersState(
      isDrawerActive: isDrawerActive ?? this.isDrawerActive,
      displayOpenStickersTooltip:
          displayOpenStickersTooltip ?? this.displayOpenStickersTooltip,
      displayClearStickersTooltip:
          displayClearStickersTooltip ?? this.displayClearStickersTooltip,
    );
  }
}
