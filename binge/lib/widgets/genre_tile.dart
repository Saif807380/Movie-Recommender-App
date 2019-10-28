import 'package:binge/models/genres.dart';
import 'package:flutter/material.dart';

class GenreTile extends StatefulWidget {
  final String genre;

  GenreTile({this.genre});

  @override
  GenreTileState createState() => GenreTileState();
}

class GenreTileState extends State<GenreTile> {
  bool value = false;

  void isPresent() {
    for (int i = 0; i < Genres.selectedGenres.length; i++) {
      if (widget.genre == Genres.selectedGenres[i]) {
        value = true;
      }
    }
  }

  void select() {
    if (value) {
      setState(() {
        value = false;
        Genres.selectedGenres.remove(widget.genre);
      });
    } else {
      setState(() {
        value = true;
        Genres.selectedGenres.add(widget.genre);
      });
    }

  }

  @override
  void initState() {
    isPresent();
  }

  @override
  Widget build(BuildContext context) {
    isPresent();
    // TODO: implement build
    return Column(
      children: <Widget>[
        CheckboxListTile(
          title: Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              widget.genre,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          value: value,
          onChanged: (value) => select(),
          activeColor: Theme.of(context).primaryColor,
          checkColor: Theme.of(context).accentColor,
        ),
        Divider(),
      ],
    );
  }
}
