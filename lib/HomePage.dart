import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
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
    setState(() {
      _selectedIndex = index;
    });
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
      body: Center(
        child: Column(
         children:[ _widgetOptions.elementAt(_selectedIndex),
         Expanded(

          child:Padding(
          padding: const EdgeInsets.only(
            left: 100, right: 100, top: 15, bottom: 0
          ),
           child:TextFormField(
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: OutlineInputBorder( 
                       borderRadius: BorderRadius.circular(10.0),
                       borderSide: BorderSide.none,
                       ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: 
                  Icon(Icons.search),
              hintText: 'Search',
              hintStyle: TextStyle(
                fontSize: 14,
              ),
            ),
            onChanged: (text) {
              text = text.toLowerCase();
            },
          ),
            )
         ),
        ]),
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