// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/bloc/bottom_navbar_bloc.dart';
import 'package:newsapp/screens/tabs/bookmarks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tabs/home_screen.dart';
import 'tabs/search_screen.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
_signOut() async {
  await _firebaseAuth.signOut();
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BottomNavBarBloc _bottomNavBarBloc;
  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191826), //warna background
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0xff191826), //warna app bar
          title: Text(
            'Project News App',
            style: TextStyle(color: Colors.white), //warna app bar text
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                _signOut();
              },
            )
          ],
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<NavBarItem>(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            switch (snapshot.data) {
              case NavBarItem.HOME:
                return HomeScreen();
              case NavBarItem.BOOKMARKS:
                return Bookmarks();
              case NavBarItem.SEARCH:
                return SearchScreen();
            }
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return Container(
            child: BottomNavigationBar(
              backgroundColor: Color(0xff191826), //warna bottom navigation
              iconSize: 20,
              unselectedItemColor: Colors.grey[700],
              unselectedFontSize: 8.5,
              selectedFontSize: 12,
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.white,
              currentIndex: snapshot.data.index,
              onTap: _bottomNavBarBloc.pickItem,
              items: [
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: 'Bookmarks',
                  icon: Icon(Icons.book_outlined),
                  activeIcon: Icon(Icons.book),
                ),
                BottomNavigationBarItem(
                  label: 'Search',
                  icon: Icon(Icons.search_outlined),
                  activeIcon: Icon(Icons.search),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
