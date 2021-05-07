part of 'stickers_bloc.dart';

class StickersState extends Equatable {
  const StickersState({
    this.isDrawerActive = false,
    this.shouldDisplayPropsReminder = true,
  });

  final bool isDrawerActive;
  final bool shouldDisplayPropsReminder;

  @override
  List<Object> get props => [isDrawerActive, shouldDisplayPropsReminder];
}
