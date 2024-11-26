import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Import http package
import 'package:foodapp/typography.dart';
import 'package:foodapp/color.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:intl/intl.dart';

class FoodOrderDetailsPage extends StatefulWidget {
  const FoodOrderDetailsPage({Key? key}) : super(key: key);

  @override
  _FoodOrderDetailsPageState createState() => _FoodOrderDetailsPageState();
}

class _FoodOrderDetailsPageState extends State<FoodOrderDetailsPage> {
  List<Map<String, dynamic>> orderData = [];  // Store fetched data
  bool isLoading = true;  // To show loading indicator while fetching data
  int _selectedMonth = DateTime.now().month;

  // Function to fetch orders from an API (replace with your API endpoint)
  Future<void> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('https://your-api-endpoint.com/orders'));  // Replace with your API
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          orderData = data.map((e) => e as Map<String, dynamic>).toList();
          isLoading = false;  // Hide loading indicator once data is fetched
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;  // Hide loading indicator on error
      });
    }
  }

  // Function to determine color based on order status
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

  // Calculate fine based on the pending status
  double _calculateMonthlyFine() {
    return orderData.fold(0, (total, order) {
      double orderFine = 0;
      (order['opt_ins'] as Map).forEach((meal, status) {
        if (status == "Pending") {
          orderFine += 100;
        }
      });
      return total + orderFine;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();  // Fetch orders when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
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
            // Scrollable Content
            Positioned.fill(
              bottom: 80, // Space for the fixed bottom card
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile Section
                    Container(
                      padding: const EdgeInsets.all(16),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sreejith',
                                    style: FontClass.title.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '9496232323',
                                    style: FontClass.subtitle,
                                  ),
                                  Text(
                                    'sreejith@gmail.com',
                                    style: FontClass.subtitle,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'BI00526',
                                        style: FontClass.subtitle,
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width / 1.5),
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
                                            SizedBox(width: 8),
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
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Dropdown Section
                          CustomDropdown(
                            hintText: 'Select Month',
                            items: const [
                              'January', 'February', 'March', 'April', 'May', 'June', 'July',
                              'August', 'September', 'October', 'November', 'December',
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedMonth = ([
                                  'January', 'February', 'March', 'April', 'May', 'June', 'July',
                                  'August', 'September', 'October', 'November', 'December'
                                ].indexOf(value!) + 1);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // Order Details Section
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Display orders or loading indicator
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: orderData.length,
                      itemBuilder: (context, index) {
                        var order = orderData[index];
                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat('dd MMM yyyy').format(DateTime.parse(order['date'])),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 20, color: Colors.grey.shade300),
                                ...((order['opt_ins'] as Map).entries.map((entry) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key.toString()[0].toUpperCase() +
                                              entry.key.toString().substring(1),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(entry.value),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            entry.value,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList()),
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
            // Bottom Card Section
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.blueAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Fine for Month: ${_calculateMonthlyFine().toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
