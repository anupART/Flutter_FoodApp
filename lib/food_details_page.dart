import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:foodapp/typography.dart';
import 'package:foodapp/color.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:intl/intl.dart';

import 'model_class.dart';

class FoodOrderDetailsPage extends StatefulWidget {
  const FoodOrderDetailsPage({Key? key}) : super(key: key);

  @override
  _FoodOrderDetailsPageState createState() => _FoodOrderDetailsPageState();
}

class _FoodOrderDetailsPageState extends State<FoodOrderDetailsPage> {
  List<Report> orderData = [];
  bool isLoading = true;

  int _selectedMonth = DateTime.now().month;


  Future<FoodModel> fetchOrders(int month) async {
    setState(() {
      isLoading = true; // Start loading
    });
    const String apiUrl = 'http://canteen.benzyinfotech.com/api/v3/customer/report';

    final Map<String, dynamic> requestBody = {
      "month": month,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZWRhNWExODU0OTFhYWE0MmY5YzMyZjRhMTU5MDM1ODk4ZjZiMzMxNWUzZjJjNGRiZDA1N2IyNGE3NTAzMDc3NDBlMjFlYjZmNGE4Mjk0MGUiLCJpYXQiOjE3MDQ4MDA4OTAuODc5OTI1OTY2MjYyODE3MzgyODEyNSwibmJmIjoxNzA0ODAwODkwLjg3OTkyOTA2NTcwNDM0NTcwMzEyNSwiZXhwIjoxNzM2NDIzMjkwLjgzNDkxMjA2MTY5MTI4NDE3OTY4NzUsInN1YiI6IjI2NSIsInNjb3BlcyI6W119.CwDEjlHoRtOXdFcaO6KGGxV202AOA7MMtJVPtKzgLqzTFzUUnDLGBd7PNAtHO2--3YOathM9HOG8hYjY8wjktXZIoCGUR9GWIaEVUxLwFq927CrSf05NuqTBTrJcDeBOjXDvKcSBiJ2A994FC2IunPcdkaZ4jpoaWBIaWueYUbHviYSQuLec3tFcAMg4njrImAlaN9k-QKkHetpdrdbUEX1Wzq4X-1QwuOx7W3W2nbbxaoNgFX1gaabxi00ZO7h5MokGvtqy_gCkS9TYoM74VfxmTyAAczjttLcPqDNiAL_ZJdutDMezw32CZj8G8l8PUL46F_BuaxatZDBUZxeClZh4_0Wvo9GX4zqF2XvHdzZHnwdB414vNCl8itaGW9w7QWbdchPOglhnek32ZmkH0MIqeOBhnAyHo5_WbP0uLd_3qmz3w04nvTbTGV25-QebaxPAsVD0-7Za1sVpqB_FD6yEeliaEzdxl_8gA5IH59uowpfPYgUIjom8NVEASuYsAwb0q3f0jhNRfwg2zmXNenoDunh_dN9l2NRjI2gdZueSMwu6IJLQK46jpn01uG2iQ1xx-pFJAGe_bzSceLsho3dbtabym3tMqi0Ac02xUP9Mn50LdkFJGNVU9jiuHQfyjQirDtGUfya3aIvpJlCGx9Cx99s_4P89uDnOiXy3A1Q',

        },
        body: jsonEncode(requestBody),
      );

      print("requstBody: ${requestBody}");

      if (response.statusCode == 200) {
        print("response: ${response.body}");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        FoodModel foodModel = FoodModel.fromJson(jsonResponse);

        setState(() {
          orderData = foodModel.reports; // Update orderData
          _cachedUserData = foodModel; // Update cached user data
          isLoading = false; // Stop loading
        });

        return foodModel;
      } else {
        setState(() {
          isLoading = false; // Stop loading in case of error
          orderData = []; // Clear previous data
        });
        throw Exception('Failed to fetch orders: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading in case of error
        orderData = []; // Clear previous data
      });
      print('Error fetching orders: $e');
      throw Exception('An error occurred while fetching orders.');
    }
  }
  Color _getStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green.shade600;
      case "Canceled":
        return Colors.red.shade600;
      case "Pending":
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
  final Map<String, int> monthMap = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };
  DateTime _parseDate(String dateString) {
    try {
      // Ensure the date is in the correct format
      final parts = dateString.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2].padLeft(2, '0'));
      return DateTime(year, month, day);
    } catch (e) {
      print('Error parsing date: $dateString');
      return DateTime.now(); // Fallback to current date
    }
  }




  double _calculateMonthlyFine() {
    return orderData.fold(0.0, (total, order) {
      // Get the optIns object from the Report (not as a Map)
      final optIns = order.optIns;  // Accessing the optIns directly
      double orderFine = 0.0;

      // Check if optIns fields are not null and check if they are "Pending"
      if (optIns.breakfast == "Pending") {
        orderFine += 100.0;
      }
      if (optIns.lunch == "Pending") {
        orderFine += 100.0;
      }
      if (optIns.dinner == "Pending") {
        orderFine += 100.0;
      }

      return total + orderFine;  // Add the fine for this order to the total
    });
  }


  late Future<FoodModel> _userDataFuture;
  FoodModel? _cachedUserData;
  @override
  void initState() {
    super.initState();

    // Fetch orders for the selected month
    _userDataFuture = fetchOrders(_selectedMonth).then((foodModel) {
      setState(() {
        _cachedUserData = foodModel; // Cache the data
      });
      return foodModel;
    });
  }


// Function to handle the month change
  void _onMonthChanged(int month) {
    setState(() {
      _selectedMonth = month; // Update the selected month number
    });

    // Now you can pass the selected month number to the API
    fetchOrders(_selectedMonth);
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'benzy',
                style: FontClass.appBar.copyWith(color: Colors.black),
              ),
              TextSpan(
                text: 'food',
                style: TextStyle(
                  fontFamily: FONT_FAMILY,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: myPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: myOnSecondaryColor,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              bottom: screenHeight * 0.1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                        child: _cachedUserData != null
                        ? UserDetailsWidget(user: _cachedUserData?.user)

                        : FutureBuilder<FoodModel>(
                          future: _userDataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data!.user != null) {
                              return UserDetailsWidget(
                                  user: snapshot.data!.user);
                            }
                            return const Center(
                                child: Text('No data available'));
                          },
                        ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Outer margin for spacing
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color for the dropdown
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ], // Subtle shadow for the dropdown to lift it off the screen
                    ),
                    child: DropdownButtonFormField<String>(
                      value: DateFormat('MMMM').format(DateTime.now()), // Set the current month as the default value
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside the dropdown
                        border: InputBorder.none, // Removing the default border for a clean look
                        hintText: 'Select Month',
                        hintStyle:FontClass.contentText, // Using a custom font style for the hint
                      ),
                      items: [
                        {'id': '1', 'month': 'January'},
                        {'id': '2', 'month': 'February'},
                        {'id': '3', 'month': 'March'},
                        {'id': '4', 'month': 'April'},
                        {'id': '5', 'month': 'May'},
                        {'id': '6', 'month': 'June'},
                        {'id': '7', 'month': 'July'},
                        {'id': '8', 'month': 'August'},
                        {'id': '9', 'month': 'September'},
                        {'id': '10', 'month': 'October'},
                        {'id': '11', 'month': 'November'},
                        {'id': '12', 'month': 'December'},
                      ].map((Map<String, String> monthData) {
                        return DropdownMenuItem<String>(
                          value: monthData['month']!, // Using month name as the value
                          child: Text(
                            monthData['month']!,
                            style: FontClass.contentText, // Custom font style for dropdown items
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value != null) {
                          // Convert the month name to its corresponding number
                          int monthNumber = monthMap[value]!;
                          print("month number : ${monthNumber}");
                          // _onMonthChanged(monthNumber);
                          fetchOrders(monthNumber);
                        }
                      },
                    ),
                  )

                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Order Details',
                        style: FontClass.title
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      isLoading
                          ? Center(child: CircularProgressIndicator(
                        color: myPrimaryColor,
                        strokeWidth: 3,
                      ))
                          : orderData.isEmpty
                          ? Center(child: Text('No orders found for this month'))
                          :  ListView.builder(
                        shrinkWrap: true, // Add this to prevent scrolling issues
                        itemCount: orderData.length,
                        itemBuilder: (context, index) {
                          var order = orderData[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                            ),
                            color: Colors.white, // White background for the card
                            elevation: 4, // Add slight shadow for card elevation
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display the date with better styling
                                  Text(
                                    DateFormat('dd MMM yyyy').format(
                                        DateTime(
                                            int.parse(order.date.split('-')[0]),
                                            int.parse(order.date.split('-')[1]),
                                            int.parse(order.date.split('-')[2])
                                        )
                                    ),
                                    style: FontClass.subtitle,
                                  ),
                                  Divider(color: Colors.grey.shade300),

                                  // Display OptIns (Breakfast, Lunch, Dinner) with better alignment and spacing
                                  ...[
                                    ['breakfast', order.optIns.breakfast],
                                    ['lunch', order.optIns.lunch],
                                    ['dinner', order.optIns.dinner]
                                  ]
                                      .where((entry) => entry[1] != null) // Only show non-null options
                                      .map((entry) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry[0].toString()[0].toUpperCase() +
                                              entry[0].toString().substring(1),
                                          style: FontClass.subtitle,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(entry[1]!), // Status color
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            entry[1]!,
                                            style: FontClass.subtitle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                                      .toList(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.blueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Fine:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${_calculateMonthlyFine().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class UserDetailsWidget extends StatelessWidget {
  final User? user;
  final bool showVegTag;

  const UserDetailsWidget({
    Key? key,
    required this.user,
    this.showVegTag = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text('No user data available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${user?.fName ?? ''} ${user?.lName ?? ''}',
          style: FontClass.title,
        ),
        Text(user?.phone ?? '', style: FontClass.subtitle),
        Text(user?.email ?? '', style: FontClass.subtitle),
        Row(
          children: [
            Text(
              user?.empId ?? '',
              style: FontClass.subtitle,
            ),
            if (showVegTag) const Spacer(),
            if (showVegTag)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: myPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: myPrimaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Veg",
                      style: TextStyle(
                        color: myPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}