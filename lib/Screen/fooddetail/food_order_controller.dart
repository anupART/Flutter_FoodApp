import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../style/color.dart';
import 'food_modelclass.dart';

class FoodOrderController extends GetxController {
  final FoodOrderService foodOrderService;

  FoodOrderController({required this.foodOrderService});

  final Rx<FoodModel?> _cachedUserData = Rx<FoodModel?>(null);
  final RxList<Report> orderData = <Report>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedMonth = DateTime.now().month.obs;

  FoodModel? get cachedUserData => _cachedUserData.value;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(selectedMonth.value);
  }

  Future<void> fetchOrders(int month) async {
    try {
      isLoading.value = true;
      final foodModel = await foodOrderService.fetchOrders(month);
      _cachedUserData.value = foodModel;
      orderData.value = foodModel.reports;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      orderData.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void fetchAllOrders() async{
    FoodModel response = await FoodOrderService().fetchOrders(0);



  }


  DateTime parseDate(String dateString) {
    try {
      final parts = dateString.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2].padLeft(2, '0'));
      return DateTime(year, month, day);
    } catch (e) {
      print('Error parsing date: $dateString');
      return DateTime.now();

    }
  }

  double calculateMonthlyFine() {
    return orderData.fold(0.0, (total, order) {
      double orderFine = 0.0;
      final optIns = order.optIns;

      if (optIns.breakfast == "Pending") orderFine += 100.0;
      if (optIns.lunch == "Pending") orderFine += 100.0;
      if (optIns.dinner == "Pending") orderFine += 100.0;

      return total + orderFine;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return deliveredOrder;
      case "Canceled":
        return cancelOrder;
      case "Pending":
        return pendingOrder;
      default:
        return Colors.grey.shade600;
    }
  }
}


class FoodOrderService {
  static const String _apiUrl = 'http://canteen.benzyinfotech.com/api/v3/customer/report';


  Future<FoodModel> fetchOrders(int month) async {
    final Map<String, dynamic> requestBody = {"month": month};

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZWRhNWExODU0OTFhYWE0MmY5YzMyZjRhMTU5MDM1ODk4ZjZiMzMxNWUzZjJjNGRiZDA1N2IyNGE3NTAzMDc3NDBlMjFlYjZmNGE4Mjk0MGUiLCJpYXQiOjE3MDQ4MDA4OTAuODc5OTI1OTY2MjYyODE3MzgyODEyNSwibmJmIjoxNzA0ODAwODkwLjg3OTkyOTA2NTcwNDM0NTcwMzEyNSwiZXhwIjoxNzM2NDIzMjkwLjgzNDkxMjA2MTY5MTI4NDE3OTY4NzUsInN1YiI6IjI2NSIsInNjb3BlcyI6W119.CwDEjlHoRtOXdFcaO6KGGxV202AOA7MMtJVPtKzgLqzTFzUUnDLGBd7PNAtHO2--3YOathM9HOG8hYjY8wjktXZIoCGUR9GWIaEVUxLwFq927CrSf05NuqTBTrJcDeBOjXDvKcSBiJ2A994FC2IunPcdkaZ4jpoaWBIaWueYUbHviYSQuLec3tFcAMg4njrImAlaN9k-QKkHetpdrdbUEX1Wzq4X-1QwuOx7W3W2nbbxaoNgFX1gaabxi00ZO7h5MokGvtqy_gCkS9TYoM74VfxmTyAAczjttLcPqDNiAL_ZJdutDMezw32CZj8G8l8PUL46F_BuaxatZDBUZxeClZh4_0Wvo9GX4zqF2XvHdzZHnwdB414vNCl8itaGW9w7QWbdchPOglhnek32ZmkH0MIqeOBhnAyHo5_WbP0uLd_3qmz3w04nvTbTGV25-QebaxPAsVD0-7Za1sVpqB_FD6yEeliaEzdxl_8gA5IH59uowpfPYgUIjom8NVEASuYsAwb0q3f0jhNRfwg2zmXNenoDunh_dN9l2NRjI2gdZueSMwu6IJLQK46jpn01uG2iQ1xx-pFJAGe_bzSceLsho3dbtabym3tMqi0Ac02xUP9Mn50LdkFJGNVU9jiuHQfyjQirDtGUfya3aIvpJlCGx9Cx99s_4P89uDnOiXy3A1Q',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return FoodModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to fetch orders: ${response.body}');
    }
  }
}