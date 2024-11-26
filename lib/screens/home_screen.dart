import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          CarouselSlider(
            options: CarouselOptions(
              height: 150.0,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 10,
              viewportFraction: 0.8,
            ),
            items: imageUrls.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
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
          SizedBox(height: 20),

        ],
      ),
    );
  }
}
