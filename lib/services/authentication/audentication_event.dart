part of 'audentication_bloc.dart';



abstract class AudenticationEvent {}

class LoginRequested extends AudenticationEvent {
  final String username;
  final String password;

  LoginRequested(this.username, this.password);
}
