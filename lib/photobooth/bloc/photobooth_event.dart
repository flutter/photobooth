part of 'photobooth_bloc.dart';

abstract class PhotoboothEvent extends Equatable {
  const PhotoboothEvent();

  @override
  List<Object> get props => [];
}

abstract class PhotoboothCharacterUpdated extends PhotoboothEvent {
  const PhotoboothCharacterUpdated({required this.update});
  final DragUpdate update;

  @override
  List<Object> get props => [update];
}

class PhotoboothAndroidUpdated extends PhotoboothCharacterUpdated {
  const PhotoboothAndroidUpdated({required DragUpdate update})
      : super(update: update);
}

class PhotoboothAndroidToggled extends PhotoboothEvent {
  const PhotoboothAndroidToggled();
}

class PhotoboothDashUpdated extends PhotoboothCharacterUpdated {
  const PhotoboothDashUpdated({required DragUpdate update})
      : super(update: update);
}

class PhotoboothDashToggled extends PhotoboothEvent {
  const PhotoboothDashToggled();
}

class PhotoboothSparkyUpdated extends PhotoboothCharacterUpdated {
  const PhotoboothSparkyUpdated({required DragUpdate update})
      : super(update: update);
}

class PhotoboothSparkyToggled extends PhotoboothEvent {
  const PhotoboothSparkyToggled();
}
