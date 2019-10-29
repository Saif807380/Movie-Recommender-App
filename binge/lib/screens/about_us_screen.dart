import 'package:binge/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  static const String routeName = '/about-us-screen';

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: Text(
        "About Us",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
    // TODO: implement build
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: appBar,
        drawer: AppDrawer(appBar),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Text(
                  "This app is a simple movie recommender app. From a vast number of available genres, the user can select genres of their liking, on the basis of which the user is presented with a list of movie recommendations. The list is sorted according to relevance and ratings to provide the best results. Simply pressing the like button adds the movies to your favourites list.\n",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "This app is developed by :\n\n1) Saif Kazi\n2) Saurav Kanegaonkar\n3) Sagar Dholakia\n",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
