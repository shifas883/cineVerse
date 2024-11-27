import 'dart:convert';

import 'package:cineVerse/models/model_class.dart';
import 'package:cineVerse/screens/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/movie/movie_bloc.dart';

class FullMovieList extends StatefulWidget {
  const FullMovieList({super.key});

  @override
  State<FullMovieList> createState() => _FullMovieListState();
}

class _FullMovieListState extends State<FullMovieList> {
  List<Movie> movies = [];
  List<Movie> filteredMovies = [];
  TextEditingController searchController = TextEditingController();
  List<Movie> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMovies());
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
      child: BlocListener<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is MovieLoaded) {
            movies = state.movies ?? [];
            filteredMovies = movies;
            setState(() {});
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            title: Text(
              "Movie List",
              style: GoogleFonts.roboto(
                color: const Color(0xFFFF7643),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
              onTap: (){

                context.read<MovieBloc>().add(FetchMovies());
                Navigator.pop(context);
                setState(() {

                });
              },
                child: Icon(Icons.arrow_back_ios)),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Movies',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFFF7643)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredMovies = movies
                          .where((movie) =>
                          movie.title.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
              ),
              Expanded(
                child: filteredMovies.isEmpty ? const Center(child: CircularProgressIndicator()) : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredMovies.length,
                  itemBuilder: (BuildContext context, int index) {
                    Movie movie = filteredMovies[index];
                    bool isFavorite =
                    favoriteMovies.any((m) => m.imdbId == movie.imdbId);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetails(movie: movie),
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
                                    movie.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      fontSize: w / 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(movie.imdbId),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}
