import 'dart:convert';

import 'package:binge/models/genres.dart';
import 'package:binge/screens/movies_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'genre_tile.dart';

class GenreList extends StatefulWidget {
  final AppBar appBar;

  GenreList(this.appBar);

  @override
  _GenreListState createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  void moviesScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(MoviesScreen.routeName);
  }

  Future<void> sendSelectedGenres() async {
    print(Genres.selectedGenres);
    final url = 'http://saifkazi.pythonanywhere.com/send_select_genres';
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "Genres": Genres.selectedGenres,
        }));
    print(response.body);
    moviesScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? (MediaQuery.of(context).size.height -
                          widget.appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).size.height * 0.01) *
                      0.1
                  : (MediaQuery.of(context).size.height -
                          widget.appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).size.height * 0.07) *
                      0.2,
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Text(
                "Please select one or more genres",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? (MediaQuery.of(context).size.height -
                          widget.appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).size.height * 0.04) *
                      0.8
                  : (MediaQuery.of(context).size.height -
                          widget.appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).size.height * 0.09) *
                      0.6,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: Genres.listOfGenres.length,
                itemBuilder: (ctx, i) {
                  return GenreTile(genre: Genres.listOfGenres[i]);
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? (MediaQuery.of(context).size.height -
                          widget.appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).size.height * 0.02) *
                      0.1
                  : (MediaQuery.of(context).size.height -
                          widget.appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).size.height * 0.07) *
                      0.2,
              alignment: Alignment.center,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  sendSelectedGenres();
                },
                child: Text(
                  "CONFIRM",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
