part of 'photobooth_bloc.dart';

abstract class PhotoboothEvent extends Equatable {
  const PhotoboothEvent();

  @override
  List<Object> get props => [];
}

class PhotoboothAndroidToggled extends PhotoboothEvent {
  const PhotoboothAndroidToggled();
}

class PhotoboothDashToggled extends PhotoboothEvent {
  const PhotoboothDashToggled();
}

class PhotoboothSparkyToggled extends PhotoboothEvent {
  const PhotoboothSparkyToggled();
}
