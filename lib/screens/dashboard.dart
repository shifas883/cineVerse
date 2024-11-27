import 'package:cineVerse/screens/home_screen.dart';
import 'package:cineVerse/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/movie/movie_bloc.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    context.read<MovieBloc>().add(FetchMovies());
    super.initState();
  }
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text('CineVerse',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color(0xFFFF7643),
          ),),
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFFFF7643),
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}