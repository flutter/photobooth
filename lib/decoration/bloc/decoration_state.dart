part of 'decoration_bloc.dart';

enum DecorationMode { active, inactive }

extension DecorationModeX on DecorationMode {
  bool get isActive => this == DecorationMode.active;
  bool get isNotActive => this == DecorationMode.inactive;
}

class DecorationState extends Equatable {
  const DecorationState({
    this.mode = DecorationMode.inactive,
    this.stickers = const <Asset>[],
  });

  final DecorationMode mode;
  final List<Asset> stickers;

  @override
  List<Object> get props => [mode, stickers];

  DecorationState copyWith({DecorationMode? mode, List<Asset>? stickers}) {
    return DecorationState(
      mode: mode ?? this.mode,
      stickers: stickers ?? this.stickers,
    );
  }
}
