import 'package:bloc/bloc.dart';
import 'package:cineVerse/models/model_class.dart';
import 'package:cineVerse/services/datasourse.dart';
import 'package:meta/meta.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final AuthRepository authRepository;

  MovieBloc(this.authRepository) : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        final movies = await authRepository.fetchMovies();
        emit(MovieLoaded(movies));
      } catch (e) {
        emit(MovieError('Failed to fetch movies'));
      }
    });
  }
}
