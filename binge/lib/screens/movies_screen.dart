import 'dart:convert';

import 'package:binge/models/genres.dart';
import 'package:binge/models/movies.dart';
import 'package:binge/widgets/app_drawer.dart';
import 'package:binge/widgets/movies_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesScreen extends StatefulWidget {
  static const String routeName = '/movies-screen';

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  bool loaded = true;

  Future<void> getSuggestions() async {
    final url = 'http://saifkazi.pythonanywhere.com/suggestions';
    final response = await http.get(url);
    setState(() {
      final Map<String, dynamic> data = jsonDecode(response.body);
      Movies.suggestions = data["List"];
    });
  }

  @override
  void initState() {
    getSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: Text(
        "Movies",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );

    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: appBar,
      drawer: AppDrawer(appBar),
      body: Column(
        children: <Widget>[
          Genres.selectedGenres.length == 0
              ? Container(
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? (MediaQuery.of(context).size.height -
                                  appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.2
                          : (MediaQuery.of(context).size.height -
                                  appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.2,
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Please select genres for suggestions..",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                )
              : !loaded
                  ? Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.height -
                                      appBar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.1
                              : (MediaQuery.of(context).size.height -
                                      appBar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.2,
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Finding movies..",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                        Container(
                          child: CircularProgressIndicator(),
                          alignment: Alignment.center,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.height -
                                      appBar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.1
                              : (MediaQuery.of(context).size.height -
                                      appBar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.2,
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Here are a few suggestions..",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.height -
                                      appBar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.9
                              : (MediaQuery.of(context).size.height -
                                      appBar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.8,
                          color: Theme.of(context).primaryColor,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: Movies.suggestions.length,
                            itemBuilder: (ctx, i) => MoviesCard(
                              appBar: appBar,
                              title: Movies.suggestions[i]["Title"],
                              rating: Movies.suggestions[i]["Rating"],
                              movieGenre: Movies.suggestions[i]["Genre"],
                              runtime: Movies.suggestions[i]["Runtime"],
                              num: i,
                            ),
                          ),
                        ),
                      ],
                    )
        ],
      ),
    );
  }
}
