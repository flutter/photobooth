part of 'stickers_bloc.dart';

enum StickersMode { active, inactive }

extension StickersModeX on StickersMode {
  bool get isActive => this == StickersMode.active;
  bool get isNotActive => this == StickersMode.inactive;
}

class StickersState extends Equatable {
  const StickersState({
    this.mode = StickersMode.inactive,
    this.stickers = const <Asset>[],
  });

  final StickersMode mode;
  final List<Asset> stickers;

  @override
  List<Object> get props => [mode, stickers];

  StickersState copyWith({StickersMode? mode, List<Asset>? stickers}) {
    return StickersState(
      mode: mode ?? this.mode,
      stickers: stickers ?? this.stickers,
    );
  }
}
