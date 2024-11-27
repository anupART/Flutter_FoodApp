import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../style/color.dart';
import '../../style/typography.dart';
import 'food_order_controller.dart';
import 'food_modelclass.dart';

class FoodOrderDetailsPage extends GetView<FoodOrderController> {
  const FoodOrderDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              bottom: MediaQuery.of(context).size.height * 0.1,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    collapsedHeight: 270,
                    pinned: true,
                    floating: true,
                    toolbarHeight: 250,
                    flexibleSpace: Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                      decoration: BoxDecoration(color: myOnSecondaryColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: RichText(
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
                          ),
                          Obx(() {
                            final user = controller.cachedUserData?.user;
                            return user != null
                                ? UserDetailsWidget(user: user)
                                : Center(child: CircularProgressIndicator());
                          }),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              width: Get.size.width / 1.2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6, spreadRadius: 2)],
                              ),
                              child: DropdownButtonFormField<int>(
                                borderRadius: BorderRadius.circular(12),
                                value: controller.selectedMonth.value,
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: InputBorder.none,
                                  hintText: 'Select Month',
                                  hintStyle: FontClass.contentText,
                                ),
                                items: List.generate(12, (index) {
                                  return DropdownMenuItem<int>(
                                    value: index + 1,
                                    child: Text(
                                      DateFormat('MMMM').format(DateTime(0, index + 1)),
                                      style: FontClass.subtitle,
                                    ),
                                  );
                                }),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedMonth.value = value;
                                    controller.fetchOrders(value);
                                  }
                                },
                                menuMaxHeight: 400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else{
                        return ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.orderData.length,
                          itemBuilder: (context, index) {
                            final order = controller.orderData[index];
                            return  controller.orderData[index].optIns != null ? OrderCard(order: order, controller: controller) : const SizedBox.shrink();
                          },
                        );
                      }

                    }),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 10,
              right: 10,
              child: Obx(() {
                final fine = controller.calculateMonthlyFine();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: myPrimaryColor,
                      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6, spreadRadius: 2)],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Fine:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${fine.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Report order;
  final FoodOrderController controller;

  const OrderCard({
    Key? key,
    required this.order,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print("Value : ${order.optIns.lunch.toString()}");



    return Container(
      child: order.optIns.lunch != null ? Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(controller.parseDate(order.date)),
                style: FontClass.subtitle.copyWith(fontSize: 16),
              ),
              Divider(color: Colors.grey.shade300),
              Column(
                children: [
                  ...[
                    ['Breakfast', order.optIns.breakfast],
                    ['Lunch', order.optIns.lunch],
                    ['Dinner', order.optIns.dinner],
                  ]
                      .where((entry) => entry[1] != null)
                      .map(
                        (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry[0]! + ':',
                            style: FontClass.subtitle.copyWith(fontSize: 16),
                          ),
                          Container(
                            width: Get.size.width / 4,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: controller.getStatusColor(entry[1]!),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                entry[1]! ?? '',
                                style: FontClass.subtitle.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .toList(),
                ],
              ),
            ],
          ),
        ),
      ) : Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(controller.parseDate(order.date)),
                style: FontClass.subtitle.copyWith(fontSize: 16),
              ),
              Divider(color: Colors.grey.shade300),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "No data found",
                            style: FontClass.subtitle.copyWith(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            '${user?.fName ?? ''} ${user?.lName ?? ''}',
            style: FontClass.title.copyWith(fontSize: 22),
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
                        style: FontClass.contentText.copyWith(
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
    );
  }
}
