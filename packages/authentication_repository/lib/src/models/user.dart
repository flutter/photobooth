import 'package:equatable/equatable.dart';

/// {@template user}
/// A model representing user
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({required this.id});

  /// The current user's id.
  final String id;

  /// Represents an empty user
  static const none = User(id: '');

  @override
  List<Object> get props => [id];
}
