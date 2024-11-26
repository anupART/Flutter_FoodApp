import 'package:flutter/material.dart';
import 'package:foodapp/typography.dart';
import 'package:foodapp/color.dart';
import 'package:intl/intl.dart';

class FoodOrderDetailsPage extends StatefulWidget {
  const FoodOrderDetailsPage({Key? key}) : super(key: key);

  @override
  _FoodOrderDetailsPageState createState() => _FoodOrderDetailsPageState();
}

class _FoodOrderDetailsPageState extends State<FoodOrderDetailsPage> {
  final List<Map<String, dynamic>> mockOrderData = [
    {
      "date": "2023-11-01",
      "opt_ins": {
        "breakfast": "Canceled",
        "lunch": "Delivered",
        "dinner": "Pending"
      }
    },
    {
      "date": "2023-11-02",
      "opt_ins": {
        "breakfast": "Delivered",
        "lunch": "Canceled",
        "dinner": "Delivered"
      }
    },
    {
      "date": "2023-11-03",
      "opt_ins": {
        "breakfast": "Pending",
        "lunch": "Pending",
        "dinner": "Canceled"
      }
    },
  ];

  int _selectedMonth = DateTime.now().month;

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

  double _calculateMonthlyFine() {
    return mockOrderData.fold(0, (total, order) {
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
                                    'Sreejith K',
                                    style: FontClass.title.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '9496362717',
                                    style: FontClass.subtitle,
                                  ),
                                  Text(
                                    'sreejith.k@benzyinfotech.com',
                                    style: FontClass.subtitle,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'BI00526',
                                        style: FontClass.subtitle,
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/1.5,),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: myPrimaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
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
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButton<int>(
                                value: _selectedMonth,
                                underline: SizedBox(),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                items: List.generate(12, (index) => index + 1)
                                    .map((month) => DropdownMenuItem(
                                  value: month,
                                  child: Text(
                                    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1],
                                    style:FontClass.subtitle
                                  ),
                                ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMonth = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Order Details Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: mockOrderData.length,
                      itemBuilder: (context, index) {
                        var order = mockOrderData[index];
                        return Card(
                          elevation: 3,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 8),
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
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(entry.value),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            entry.value,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Add extra space at the bottom to prevent content
                    // from being hidden behind the fixed card
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Fixed Total Fine Card at the Bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Fine (Monthly):',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        '₹${_calculateMonthlyFine()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}