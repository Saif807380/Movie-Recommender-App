import 'dart:convert';

import 'package:binge/models/movies.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieDetailScreen extends StatefulWidget {
  static const String routeName = '/movie-detail-screen';

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int num;
  bool value1;
  bool value;
  bool flag = false;

  void isPresent() {
    setState(() {
      value1 = value;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final Map<String, dynamic> routeArgs =
        ModalRoute.of(context).settings.arguments;
    num = routeArgs["num"];
    value = routeArgs["value"];
    isPresent();
  }

  Future<void> sendLikedMovies() async {
    final url = 'http://saifkazi.pythonanywhere.com/send_liked_movies';
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "Liked_Movies": Movies.likedMovies,
        }));
    print(response.body);
  }

  void liked() {
    if (value1) {
      setState(() {
        Movies.likedMovies.remove(Movies.likedMovies[num]);
        value1 = false;
      });
    } else {
      setState(() {
        for (int i = 0; i < Movies.likedMovies.length; i++) {
          if (Movies.suggestions[num] == Movies.likedMovies[i]) {
            flag = true;
          }
        }
        if (!flag) {
          Movies.likedMovies.add(Movies.suggestions[num]);
          value1 = true;
        }
      });
    }
    sendLikedMovies();
  }

  Future<bool> goBack(BuildContext context) async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () => goBack(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, value1),
          ),
          title: Text(
            "Movie Info",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Card(
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      Movies.suggestions[num]["Title"],
                      style: TextStyle(
                          fontSize: 34,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Genres : \n\t\t\t\t\t\t\t\t\t" +
                          Movies.suggestions[num]["Genre"].toString(),
                      style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Rating : " +
                          Movies.suggestions[num]["Rating"].toString(),
                      style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description : \n\t\t\t\t\t\t\t\t\t" +
                          Movies.suggestions[num]["Description"].toString(),
                      style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Director : \n\t\t\t\t\t\t\t\t\t" +
                          Movies.suggestions[num]["Director"].toString(),
                      style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Cast : \n\t\t\t\t\t\t\t\t\t" +
                          Movies.suggestions[num]["Cast"].toString(),
                      style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Release Year : " +
                          Movies.suggestions[num]["Release"].toString(),
                      style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Runtime : " +
                          (Movies.suggestions[num]["Runtime"] / 60)
                              .toStringAsFixed(0) +
                          " hrs " +
                          (Movies.suggestions[num]["Runtime"] % 60).toString() +
                          " mins ",
                      style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: liked,
          elevation: 5,
          child: Icon(value1 ? Icons.favorite : Icons.favorite_border),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
