import 'dart:convert';

import 'package:binge/screens/about_us_screen.dart';
import 'package:binge/screens/movie_detail_screen.dart';
import 'package:binge/screens/movies_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/genres.dart';
import 'models/movies.dart';
import 'screens/fav_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static bool loaded = false;

  Future<void> getSelectedGenres() async {
    final url = 'http://saifkazi.pythonanywhere.com//get_select_genres';
    final response = await http.get(url);
    setState(() {
      final Map<String, dynamic> data = jsonDecode(response.body);
      Genres.selectedGenres = data["Genres"];
      Movies.likedMovies = data["Liked_Movies"];
      new Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          loaded = true;
        });
      });

    });
  }

  @override
  void initState() {
    getSelectedGenres();
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData myTheme = ThemeData(
      primaryColor: Color.fromRGBO(23, 32, 42, 1),
      accentColor: Color.fromRGBO(205, 97, 85, 1),
      fontFamily: 'Raleway',
    );
    return MaterialApp(
      title: 'Binge!',
      theme: myTheme,
      home: !loaded
          ? SplashScreen()
          : Genres.selectedGenres.length != 0 ? MoviesScreen() : HomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        MoviesScreen.routeName: (ctx) => MoviesScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        MovieDetailScreen.routeName: (ctx) => MovieDetailScreen(),
        FavScreen.routeName: (ctx) => FavScreen(),
        AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
      },
    );
  }
}
