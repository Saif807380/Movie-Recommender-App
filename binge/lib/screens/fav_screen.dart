import 'dart:convert';

import 'package:binge/models/movies.dart';
import 'package:binge/widgets/app_drawer.dart';
import 'package:binge/widgets/fav_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavScreen extends StatefulWidget {
  static const String routeName = '/fav-screen';

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  bool loaded = false;

  Future<void> getFavourites() async {
    final url = 'http://saifkazi.pythonanywhere.com/get_select_genres';
    final response = await http.get(url);
    print(response.body);
    setState(() {
      final Map<String, dynamic> data = jsonDecode(response.body);
      Movies.likedMovies = data["Liked_Movies"];
      loaded = true;
    });
  }

  @override
  void initState() {
    getFavourites();
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: Text(
        "Favourites",
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
          !loaded
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
                        "Getting Favourites..",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                )
              : Movies.likedMovies.length == 0
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
                            "No favourites found..",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
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
                            "Here are your favourites..",
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
                            itemCount: Movies.likedMovies.length,
                            itemBuilder: (ctx, i) => FavCard(
                              appBar: appBar,
                              title: Movies.likedMovies[i]["Title"],
                              rating: Movies.likedMovies[i]["Rating"],
                              movieGenre: Movies.likedMovies[i]["Genre"],
                              runtime: Movies.likedMovies[i]["Runtime"],
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
