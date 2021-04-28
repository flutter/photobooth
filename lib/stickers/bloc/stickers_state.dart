part of 'stickers_bloc.dart';

class StickersState extends Equatable {
  const StickersState({
    this.isDrawerActive = false,
    this.displayOpenStickersTooltip = true,
  });

  final bool isDrawerActive;
  final bool displayOpenStickersTooltip;

  @override
  List<Object> get props => [isDrawerActive, displayOpenStickersTooltip];

  StickersState copyWith({
    bool? isDrawerActive,
    bool? displayOpenStickersTooltip,
  }) {
    return StickersState(
      isDrawerActive: isDrawerActive ?? this.isDrawerActive,
      displayOpenStickersTooltip:
          displayOpenStickersTooltip ?? this.displayOpenStickersTooltip,
    );
  }
}
