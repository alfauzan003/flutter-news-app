import 'package:flutter/material.dart';
import '../../widgets/headline_slider.dart';
import '../../widgets/hot_news.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HeadlingSliderWidget(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Text(
                "Seputar Indonesia",
                style: TextStyle(
                    color: Color(0xFFE5E5E5),
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
            ],
          ),
        ),
        HotNewsWidget()
      ],
    );
  }
}
