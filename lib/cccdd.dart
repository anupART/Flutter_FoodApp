// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:foodapp/typography.dart';
// import 'package:foodapp/color.dart';
// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:intl/intl.dart';
//
// import 'model_class.dart';
//
// class FoodOrderDetailsPage extends StatefulWidget {
//   const FoodOrderDetailsPage({Key? key}) : super(key: key);
//
//   @override
//   _FoodOrderDetailsPageState createState() => _FoodOrderDetailsPageState();
// }
//
// class _FoodOrderDetailsPageState extends State<FoodOrderDetailsPage> {
//   List<Map<String, dynamic>> orderData = [];
//   bool isLoading = true;
//   int _selectedMonth = DateTime.now().month;
//
//   Future<FoodModel> fetchOrders() async {
//     const String apiUrl =
//         'http://canteen.benzyinfotech.com/api/v3/customer/report';
//     final Map<String, dynamic> requestBody = {
//       "month": _selectedMonth,
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization':
//           'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZWRhNWExODU0OTFhYWE0MmY5YzMyZjRhMTU5MDM1ODk4ZjZiMzMxNWUzZjJjNGRiZDA1N2IyNGE3NTAzMDc3NDBlMjFlYjZmNGE4Mjk0MGUiLCJpYXQiOjE3MDQ4MDA4OTAuODc5OTI1OTY2MjYyODE3MzgyODEyNSwibmJmIjoxNzA0ODAwODkwLjg3OTkyOTA2NTcwNDM0NTcwMzEyNSwiZXhwIjoxNzM2NDIzMjkwLjgzNDkxMjA2MTY5MTI4NDE3OTY4NzUsInN1YiI6IjI2NSIsInNjb3BlcyI6W119.CwDEjlHoRtOXdFcaO6KGGxV202AOA7MMtJVPtKzgLqzTFzUUnDLGBd7PNAtHO2--3YOathM9HOG8hYjY8wjktXZIoCGUR9GWIaEVUxLwFq927CrSf05NuqTBTrJcDeBOjXDvKcSBiJ2A994FC2IunPcdkaZ4jpoaWBIaWueYUbHviYSQuLec3tFcAMg4njrImAlaN9k-QKkHetpdrdbUEX1Wzq4X-1QwuOx7W3W2nbbxaoNgFX1gaabxi00ZO7h5MokGvtqy_gCkS9TYoM74VfxmTyAAczjttLcPqDNiAL_ZJdutDMezw32CZj8G8l8PUL46F_BuaxatZDBUZxeClZh4_0Wvo9GX4zqF2XvHdzZHnwdB414vNCl8itaGW9w7QWbdchPOglhnek32ZmkH0MIqeOBhnAyHo5_WbP0uLd_3qmz3w04nvTbTGV25-QebaxPAsVD0-7Za1sVpqB_FD6yEeliaEzdxl_8gA5IH59uowpfPYgUIjom8NVEASuYsAwb0q3f0jhNRfwg2zmXNenoDunh_dN9l2NRjI2gdZueSMwu6IJLQK46jpn01uG2iQ1xx-pFJAGe_bzSceLsho3dbtabym3tMqi0Ac02xUP9Mn50LdkFJGNVU9jiuHQfyjQirDtGUfya3aIvpJlCGx9Cx99s_4P89uDnOiXy3A1Q'
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//
//         print("json response: ${FoodModel.fromJson(jsonResponse)}");
//         return FoodModel.fromJson(jsonResponse);
//       } else {
//
//         throw Exception('Failed to fetch orders: ${response.body}');
//       }
//     } catch (e) {
//       print('Error fetching orders: $e');
//       throw Exception('An error occurred while fetching orders.');
//     }
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Delivered":
//         return Colors.green.shade600;
//       case "Canceled":
//         return Colors.red.shade600;
//       case "Pending":
//         return Colors.orange.shade600;
//       default:
//         return Colors.grey.shade600;
//     }
//   }
//
//   double _calculateMonthlyFine() {
//     return orderData.fold(0, (total, order) {
//       double orderFine = 0;
//       (order['opt_ins'] as Map).forEach((meal, status) {
//         if (status == "Pending") {
//           orderFine += 100;
//         }
//       });
//       return total + orderFine;
//     });
//   }
//   late Future<FoodModel> _userDataFuture;
//   FoodModel? _cachedUserData;
//   @override
//   void initState() {
//     super.initState();
//     _userDataFuture = fetchOrders().then((foodModel) {
//       setState(() {
//         _cachedUserData = foodModel;
//       });
//       return foodModel;
//     });
//   }
//   void _onMonthChanged(String? value) {
//     if (value != null) {
//       setState(() {
//         _selectedMonth = [
//           'January', 'February', 'March', 'April', 'May', 'June',
//           'July', 'August', 'September', 'October', 'November', 'December'
//         ].indexOf(value) + 1;
//         isLoading = true;
//       });
//       fetchOrders();
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         title: RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: 'benzy',
//                 style: FontClass.appBar.copyWith(color: Colors.black),
//               ),
//               TextSpan(
//                 text: 'food',
//                 style: TextStyle(
//                   fontFamily: FONT_FAMILY,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                   color: myPrimaryColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: myOnSecondaryColor,
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               bottom: screenHeight * 0.1,
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(screenWidth * 0.04),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(20),
//                             bottomRight: Radius.circular(20),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Flexible(
//                                   child: _cachedUserData != null
//                                       ? Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         '${_cachedUserData!.user?.fName ?? ''} ${_cachedUserData!.user?.lName ?? ''}',
//                                         style: FontClass.title,
//                                       ),
//                                       Text(_cachedUserData!.user?.phone ?? '', style: FontClass.subtitle),
//                                       Text(_cachedUserData!.user?.email ?? '', style: FontClass.subtitle),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             _cachedUserData!.user?.empId ?? '',
//                                             style: FontClass.subtitle,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   )
//
//                                       : FutureBuilder<FoodModel>(
//                                     future: _userDataFuture,
//                                     builder: (context, snapshot) {
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.waiting) {
//                                         return const Center(
//                                             child: CircularProgressIndicator());
//                                       } else if (snapshot.hasError) {
//                                         return Center(
//                                           child:
//                                           Text('Error: ${snapshot.error}'),
//                                         );
//                                       } else if (snapshot.hasData &&
//                                           snapshot.data!.user != null) {
//                                         final user = snapshot.data!.user!;
//                                         return Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                                 '${user.fName ?? ''} ${user.lName ?? ''}',
//                                                 style: FontClass.title),
//                                             Text(user.phone ?? '',
//                                                 style: FontClass.subtitle),
//                                             Text(user.email ?? '',
//                                                 style: FontClass.subtitle),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   user.empId ?? '',
//                                                   style: FontClass.subtitle,
//                                                 ),
//                                                 Spacer(),
//                                                 Container(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(
//                                                       horizontal: 12,
//                                                       vertical: 6),
//                                                   decoration: BoxDecoration(
//                                                     color: myPrimaryColor
//                                                         .withOpacity(0.1),
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         10),
//                                                   ),
//                                                   child: Row(
//                                                     children: [
//                                                       Icon(
//                                                         Icons.circle,
//                                                         color: myPrimaryColor,
//                                                         size: 16,
//                                                       ),
//                                                       SizedBox(width: 8),
//                                                       Text(
//                                                         "Veg",
//                                                         style: TextStyle(
//                                                           color: myPrimaryColor,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         );
//                                       }
//                                       return const Center(
//                                           child: Text('No data available'));
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: screenHeight * 0.02),
//                             SizedBox(height: screenHeight * 0.02),
//                             DropdownButtonFormField<String>(
//                               value: DateFormat('MMMM').format(DateTime.now()), // Set the current month as the default value
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                               ),
//                               hint: Text('Select Month'),
//                               items: const [
//                                 'January', 'February', 'March', 'April', 'May', 'June',
//                                 'July', 'August', 'September', 'October', 'November', 'December',
//                               ].map((String month) {
//                                 return DropdownMenuItem<String>(
//                                   value: month,
//                                   child: Text(month),
//                                 );
//                               }).toList(),
//                               onChanged: (String? value) {
//                                 if (value != null) {
//                                   _onMonthChanged(value); // Call your existing function to handle month changes
//                                 }
//                               },
//                             ),
//
//
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//                       Text(
//                         'Order Details',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.05,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.01),
//                       isLoading
//                           ? Center(child: CircularProgressIndicator())
//                           : orderData.isEmpty
//                           ? Center(child: Text('No orders found for this month'))
//                           : ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: orderData.length,
//                         itemBuilder: (context, index) {
//                           var order = orderData[index];
//                           return Card(
//                             margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//                             child: Padding(
//                               padding: EdgeInsets.all(screenWidth * 0.04),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     DateFormat('dd MMM yyyy').format(
//                                         DateTime.parse(order['date'])),
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.04,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Divider(color: Colors.grey.shade300),
//                                   ...(order['opt_ins'] as Map)
//                                       .entries
//                                       .map((entry) => Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         entry.key.toString()[0].toUpperCase() +
//                                             entry.key.toString().substring(1),
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           color: Colors.grey.shade800,
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           color: _getStatusColor(entry.value),
//                                           borderRadius: BorderRadius.circular(10),
//                                         ),
//                                         child: Text(
//                                           entry.value,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ))
//                                       .toList(),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 color: Colors.blueAccent,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Total Fine:',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       '₹${_calculateMonthlyFine().toStringAsFixed(2)}',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
