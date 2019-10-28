import 'package:binge/widgets/app_drawer.dart';
import 'package:binge/widgets/genre_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        "Genres",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
    // TODO: implement build
    return Scaffold(
      appBar: appBar,
      body: GenreList(appBar),
      drawer: AppDrawer(appBar),
    );
  }
}
