import 'package:cineVerse/screens/favorites_screen.dart';
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
    print("called api");
    context.read<MovieBloc>().add(FetchMovies());
    super.initState();
  }
  int _currentIndex = 0;

  // List of pages corresponding to the BottomNavigationBar items
  final List<Widget> _pages = [
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Removes the leading icon
        title: Text('CineVerse',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: Color(0xFFFF7643),
        ),),
      ),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFFF7643),
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab
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
    );
  }
}