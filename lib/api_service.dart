// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'model_class.dart';
//
// Future<FoodModel> fetchOrders() async {
//   final url = 'http://canteen.benzyinfotech.com/api/v3/customer/report';
//
//   // Create the body of the request
//   final Map<String, dynamic> requestBody = {
//     // Add any required parameters for the POST request here
//     "month": 11,
//   };
//
//   // Send a POST request
//   final response = await http.post(
//     Uri.parse(url),
//     headers: {
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode(requestBody),
//   );
//
//   if (response.statusCode == 200) {
//     // If the server returns a 200 OK response, parse the JSON
//     return FoodModel.fromJson(json.decode(response.body));
//   } else {
//     // If the server returns an error, throw an exception
//     throw Exception('Failed to load orders');
//   }
// }
