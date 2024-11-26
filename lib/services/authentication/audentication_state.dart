part of 'audentication_bloc.dart';

@immutable
sealed class AudenticationState {}

final class AudenticationInitial extends AudenticationState {}

class AuthInitial extends AudenticationState {}

class AuthLoading extends AudenticationState {}

class AuthSuccess extends AudenticationState {
  final LoginResponse response;

  AuthSuccess(this.response);
}

class AuthFailure extends AudenticationState {
  final String error;

  AuthFailure(this.error);
}