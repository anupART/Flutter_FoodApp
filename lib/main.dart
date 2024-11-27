import 'package:flutter/material.dart';
import 'package:foodapp/typography.dart';

import 'color.dart';
import 'food_details_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const FoodOrderDetailsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: myPrimaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedLabelStyle: FontClass.infoText,
        unselectedLabelStyle: FontClass.infoText,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedIndex == 0) // Add line when selected
                  Container(
                    height: 2,
                    width: 24,
                    color: myPrimaryColor, // Customize line color
                  ),
                Icon(Icons.home_outlined),
              ],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedIndex == 1) // Add line when selected
                  Container(
                    height: 2,
                    width: 24,
                    color: myPrimaryColor, // Customize line color
                  ),
                Icon(Icons.fastfood),
              ],
            ),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
