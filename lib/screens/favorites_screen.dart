import 'dart:convert';

import 'package:cineVerse/models/model_class.dart';
import 'package:cineVerse/screens/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/movie/movie_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Movie> movies = [];
  List<Movie> filteredMovies = [];
  TextEditingController searchController = TextEditingController();
  List<Movie> favoriteMovies = []; // List to store favorite movies

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedFavorites = prefs.getString('favoriteMovies');
    if (storedFavorites != null) {
      List decoded = jsonDecode(storedFavorites);
      setState(() {
        favoriteMovies =
            decoded.map((movieJson) => Movie.fromJson(movieJson)).toList();
      });
    }
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedFavorites =
    jsonEncode(favoriteMovies.map((movie) => movie.toJson()).toList());
    await prefs.setString('favoriteMovies', encodedFavorites);
  }

  void _toggleFavorite(Movie movie) {
    setState(() {
      if (favoriteMovies.any((m) => m.imdbId == movie.imdbId)) {
        favoriteMovies.removeWhere((m) => m.imdbId == movie.imdbId);
      } else {
        favoriteMovies.add(movie);
      }
      _saveFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return PopScope(
      onPopInvokedWithResult: (result, _) {
        context.read<MovieBloc>().add(FetchMovies());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          title: Text(
            "Favorite List",
            style: GoogleFonts.roboto(
              color: const Color(0xFFFF7643),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: GestureDetector(onTap: () {
            context.read<MovieBloc>().add(FetchMovies());
            Navigator.pop(context);},
              child: Icon(Icons.arrow_back_ios)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: favoriteMovies.length,
                itemBuilder: (BuildContext context, int index) {
                  Movie movie = favoriteMovies[index];
                  bool isFavorite =
                  favoriteMovies.any((m) => m.imdbId == movie.imdbId);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetails(movie: favoriteMovies[index]),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Movie Poster
                          Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(movie.posterURL),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Movie Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  favoriteMovies[index].title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    fontSize: w / 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(favoriteMovies[index].imdbId),
                              ],
                            ),
                          ),
                          // Favorite Icon
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              _toggleFavorite(movie);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
