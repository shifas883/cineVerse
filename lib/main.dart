import 'package:cineVerse/screens/login_screen.dart';
import 'package:cineVerse/screens/splash_screen.dart';
import 'package:cineVerse/services/authentication/audentication_bloc.dart';
import 'package:cineVerse/services/datasourse.dart';
import 'package:cineVerse/services/movie/movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AudenticationBloc(AuthRepository()),
        ),
        BlocProvider(
          create: (context) => MovieBloc(AuthRepository()),),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

