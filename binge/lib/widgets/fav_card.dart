import 'dart:convert';

import 'package:binge/models/movies.dart';
import 'package:binge/screens/movie_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FavCard extends StatefulWidget {
  final String title;
  final rating;
  final movieGenre;
  final runtime;
  final AppBar appBar;
  final int num;

  FavCard(
      {this.appBar,
      this.title,
      this.rating,
      this.movieGenre,
      this.runtime,
      this.num});

  @override
  _FavCardState createState() => _FavCardState();
}

class _FavCardState extends State<FavCard> {
  bool value = false, flag = false;

  void isPresent() {
    for (int i = 0; i < Movies.likedMovies.length; i++) {
      if (widget.title == Movies.likedMovies[i]["Title"]) {
        value = true;
      }
    }
  }


  Future<void> sendLikedMovies() async {
    final url = 'http://saifkazi.pythonanywhere.com//send_liked_movies';
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
    if (value) {
      setState(() {
        Movies.likedMovies.remove(Movies.likedMovies[widget.num]);
        value = false;
      });
    } else {
      setState(() {
        for (int i = 0; i < Movies.likedMovies.length; i++) {
          if (Movies.likedMovies[widget.num] == Movies.likedMovies[i]) {
            flag = true;
            break;
          }
        }
        if (!flag || Movies.likedMovies.length == 0) {
          Movies.likedMovies.add(Movies.suggestions[widget.num]);
          value = true;
        }
      });
    }
    sendLikedMovies();
  }

  void showInfo() async {
    value = await Navigator.of(context).pushNamed(MovieDetailScreen.routeName,
        arguments: {"num": widget.num, "value": value}) as bool;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    isPresent();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // TODO: implement build
    return InkWell(
      onTap: showInfo,
      child: Container(
        padding: EdgeInsets.all(7),
        height: (MediaQuery.of(context).size.height -
                widget.appBar.preferredSize.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).size.height * 0.04) *
            0.3,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  widget.title,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 26),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 3),
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Genres : " + widget.movieGenre.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 10, right: 10),
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Runtime : " +
                      (widget.runtime / 60).toStringAsFixed(0) +
                      " hrs " +
                      (widget.runtime % 60).toString() +
                      " mins ",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 15,
                    width: 240,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        FractionallySizedBox(
                          widthFactor: widget.rating / 10,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(widget.rating.toString() + " / 10"),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: liked,
                      color: Theme.of(context).accentColor,
                      icon: Icon(
                        value ? Icons.favorite : Icons.favorite_border,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
