import 'package:bloc/bloc.dart';
import 'package:cineVerse/models/model_class.dart';
import 'package:cineVerse/services/datasourse.dart';
import 'package:meta/meta.dart';

part 'audentication_event.dart';
part 'audentication_state.dart';


class AudenticationBloc extends Bloc<AudenticationEvent, AudenticationState> {
  final AuthRepository authRepository;

  AudenticationBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final response = await authRepository.login(
          LoginRequest(username: event.username, password: event.password),
        );
        emit(AuthSuccess(response));

      } catch (e) {

        emit(AuthFailure(e.toString()));
      }
    });
  }
}
