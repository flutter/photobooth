import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc({
    this.delay = Duration.zero,
  }) : super(const ShareState.initial());

  final Duration delay;

  @override
  Stream<ShareState> mapEventToState(
    ShareEvent event,
  ) async* {
    if (event is ShareOnTwitter) {
      yield* _mapShareOnTwitterToState(event);
    } else if (event is ShareOnFacebook) {
      yield* _mapShareOnFacebookToState(event);
    }
  }

  Stream<ShareState> _mapShareOnTwitterToState(ShareOnTwitter event) async* {
    yield const ShareState.loading();
    await Future.delayed(delay);
    yield const ShareState.success();
  }

  Stream<ShareState> _mapShareOnFacebookToState(ShareOnFacebook event) async* {
    yield const ShareState.loading();
    await Future.delayed(delay);
    yield const ShareState.error();
  }
}
