import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  const SignInState({
    this.username = '',
    this.password = '',
    this.fetching = false,
  });

  final String username, password;
  final bool fetching;

  SignInState copyWith({
    String? username,
    String? password,
    bool? fetching,
  }) {
    return SignInState(
      username: username ?? this.username,
      password: password ?? this.password,
      fetching: fetching ?? this.fetching,
    );
  }

  @override
  List<Object?> get props => [
        username,
        password,
        fetching,
      ];
}

class Permission extends Equatable {
  const Permission(this.id, this.name);

  final int id;
  final String name;

  Permission copyWith({int? id, String? name}) {
    return Permission(
      id ?? this.id,
      name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
