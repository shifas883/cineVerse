import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cineVerse/common_widgets/movie_card.dart';
import 'package:cineVerse/screens/movie_details.dart';
import 'package:cineVerse/services/movie/movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/model_class.dart';
import 'favorites_screen.dart';
import 'full_movie_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<String> imageUrls = [
    'https://wallpapercave.com/wp/wp1946074.jpg',
    'https://img00.deviantart.net/5aee/i/2017/215/9/6/justice_league_movie_banner_poster_by_arkhamnatic-dbir20a.png',
    'https://images.hdqwalls.com/download/the-batman-2020-movie-poster-5k-gg-2560x1600.jpg',
    'https://img1.hotstarext.com/image/upload/f_auto/sources/r1/cms/prod/4298/674298-h',
  ];

  final List<String> movieTitles = [
    "Movie 1",
    "Movie 2",
    "Movie 3",
    "Movie 4",
  ];

  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  List<Movie> movies = [];
  @override
  Widget build(BuildContext context) {
    return BlocListener<MovieBloc, MovieState>(
  listener: (context, state) {
    if(state is MovieLoading){
      print("loading");
    }
    if(state is MovieLoaded){
      movies=state.movies??[];
      setState(() {

      });
    }
    // TODO: implement listener
  },
  child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: 150.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 10,
                viewportFraction: 0.8,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageUrls.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == entry.key
                          ? const Color(0xffFF7643)
                          : Colors.grey.withOpacity(0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Global Trending",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const FullMovieList()));
                    },
                    child: Text("View all",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF7643)
                    ),),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: movies.length>=5?5:movies.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              MovieDetails(movie: movies[index],)));
                    },
                    imdb: movies[index].imdbId,
                    name: movies[index].title,
                    imageUrl: movies[index].posterURL,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recently Viewed",
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                          const FavoritesScreen()));
                    },
                    child: Text("View all",
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFF7643)
                      ),),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: movies.length>=5?5:movies.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              MovieDetails(movie: movies[index],)));
                    },
                    imdb: movies[index].imdbId,
                    name: movies[index].title,
                    imageUrl: movies[index].posterURL,
                  );
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    ),
);
  }
}
