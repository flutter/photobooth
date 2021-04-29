part of 'stickers_bloc.dart';

class StickersState extends Equatable {
  const StickersState({this.isDrawerActive = false});

  final bool isDrawerActive;

  @override
  List<Object> get props => [isDrawerActive];

  StickersState copyWith({bool? isDrawerActive}) {
    return StickersState(
      isDrawerActive: isDrawerActive ?? this.isDrawerActive,
    );
  }
}
