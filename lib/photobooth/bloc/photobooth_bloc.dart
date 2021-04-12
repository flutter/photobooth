import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'photobooth_event.dart';
part 'photobooth_state.dart';

class PhotoboothBloc extends Bloc<PhotoboothEvent, PhotoboothState> {
  PhotoboothBloc() : super(const PhotoboothState());

  @override
  Stream<PhotoboothState> mapEventToState(PhotoboothEvent event) async* {
    if (event is PhotoboothAndroidToggled) {
      yield state.copyWith(isAndroidSelected: !state.isAndroidSelected);
    } else if (event is PhotoboothDashToggled) {
      yield state.copyWith(isDashSelected: !state.isDashSelected);
    } else if (event is PhotoboothSparkyToggled) {
      yield state.copyWith(isSparkySelected: !state.isSparkySelected);
    }
  }
}
