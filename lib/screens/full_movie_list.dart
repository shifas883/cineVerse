import 'package:cineVerse/models/model_class.dart';
import 'package:cineVerse/screens/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/movie/movie_bloc.dart';

class FullMovieList extends StatefulWidget {
  const FullMovieList({super.key});

  @override
  State<FullMovieList> createState() => _FullMovieListState();
}

class _FullMovieListState extends State<FullMovieList> {
  @override
  void initState() {
    context.read<MovieBloc>().add(FetchMovies());
    super.initState();
  }

  List<Movie> movies = [];
  List<Movie> filteredMovies = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return BlocListener<MovieBloc, MovieState>(
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
              color: Color(0xFFFF7643),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Search TextField
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Movies',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFFF7643)),
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredMovies.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              MovieDetails(movie: filteredMovies[index],)));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                image:
                                NetworkImage(filteredMovies[index].posterURL),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Movie Info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: w / 1.7,
                                child: Text(
                                  filteredMovies[index].title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    fontSize: w / 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(filteredMovies[index].imdbId),
                            ],
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
