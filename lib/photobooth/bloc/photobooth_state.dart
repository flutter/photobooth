part of 'photobooth_bloc.dart';

class PhotoboothState extends Equatable {
  const PhotoboothState({
    this.isAndroidSelected = false,
    this.isDashSelected = false,
    this.isSparkySelected = false,
  });

  final bool isAndroidSelected;
  final bool isDashSelected;
  final bool isSparkySelected;

  @override
  List<Object> get props => [
        isAndroidSelected,
        isDashSelected,
        isSparkySelected,
      ];

  PhotoboothState copyWith({
    bool? isAndroidSelected,
    bool? isDashSelected,
    bool? isSparkySelected,
  }) {
    return PhotoboothState(
      isAndroidSelected: isAndroidSelected ?? this.isAndroidSelected,
      isDashSelected: isDashSelected ?? this.isDashSelected,
      isSparkySelected: isSparkySelected ?? this.isSparkySelected,
    );
  }
}
