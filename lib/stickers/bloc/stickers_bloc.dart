import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stickers_event.dart';
part 'stickers_state.dart';

class StickersBloc extends Bloc<StickersEvent, StickersState> {
  StickersBloc() : super(const StickersState()) {
    on<StickersDrawerToggled>(
      (event, emit) => emit(
        state.copyWith(
          isDrawerActive: !state.isDrawerActive,
          shouldDisplayPropsReminder: false,
        ),
      ),
    );
    on<StickersDrawerTabTapped>(
      (event, emit) => emit(
        state.copyWith(tabIndex: event.index),
      ),
    );
  }
}
