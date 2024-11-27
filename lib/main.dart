import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'Screen/fooddetail/food_order_controller.dart';
import 'style/color.dart';
import 'Screen/fooddetail/fooddetails_view.dart';

import 'Screen/home_page.dart';

void main() {
  final foodOrderService = FoodOrderService();
  Get.put(FoodOrderController(foodOrderService: foodOrderService));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:FoodOrderDetailsPage(),
    );
  }
}

// class MainNavigationScreen extends StatefulWidget {
//   @override
//   _MainNavigationScreenState createState() => _MainNavigationScreenState();
// }
//
// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _pages = [
//     const HomePage(),
//     const FoodOrderDetailsPage(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: myPrimaryColor,
//         unselectedItemColor: Colors.grey,
//         backgroundColor: Colors.white,
//         selectedLabelStyle: FontClass.infoText,
//         unselectedLabelStyle: FontClass.infoText,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//             icon: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (_selectedIndex == 0) // Add line when selected
//                   Container(
//                     height: 2,
//                     width: 24,
//                     color: myPrimaryColor, // Customize line color
//                   ),
//                 Icon(Icons.home_outlined),
//               ],
//             ),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (_selectedIndex == 1) // Add line when selected
//                   Container(
//                     height: 2,
//                     width: 24,
//                     color: myPrimaryColor, // Customize line color
//                   ),
//                 Icon(Icons.fastfood),
//               ],
//             ),
//             label: 'Orders',
//           ),
//         ],
//       ),
//     );
//   }
// }
