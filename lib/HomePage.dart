import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gopharma/routes_name.dart';
import 'package:gopharma/screens/home/cart_tab.dart';
import 'package:gopharma/screens/home/home_tab.dart';
import 'package:gopharma/screens/home/profile_tab.dart';

class HomePage extends StatefulWidget {
  final int initPage;
  const HomePage({Key? key, this.initPage = 0}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      " ",
      style: optionStyle,
    ),
    Text(
      'Market: Not Finish Yet',
      style: optionStyle,
    ),
    Text(
      'Account: Not Finish Yet',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {

      _selectedIndex = index;
    pageController.jumpToPage(index);

    // if (index == 2) {
    //   Navigator.pushNamed(context, routeProfile);
    // }
  }

  @override
  void initState() {
    _selectedIndex = widget.initPage;
    pageController = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.cyan.shade400,
      ),
      backgroundColor: Colors.cyan.shade300,
      body: PageView(
        controller: pageController,
        onPageChanged: (tab) {
          setState(() {
            _selectedIndex = tab;
          });
        },
        children: const [
          HomeTab(),
          CartTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.cyan.shade400,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
