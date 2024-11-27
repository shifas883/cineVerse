import 'package:cineVerse/cache/save_user_data.dart';
import 'package:dio/dio.dart';

import '../models/model_class.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<LoginResponse> login(LoginRequest request) async {
    print("user name${request.username}");
    print("user name${request.password}");
    final response = await _dio.post(
      'https://dummyjson.com/auth/login',
      data: {
        'username': request.username,
        'password': request.password,
      },
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(response.data);

      print('Access Token: ${loginResponse.accessToken}');
      saveLoginData(loginResponse);
    } else {
      throw Exception('Failed to login');
    }

    return LoginResponse.fromJson(response.data);
  }

  Future<List<Movie>> fetchMovies() async {
    try {
      final response = await _dio.get('https://api.sampleapis.com/movies/animation');
      print("list response$response");
      return (response.data as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();
    } catch (e) {
      throw Exception('Failed to load movies');
    }
  }
}
