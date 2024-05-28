// import 'package:ebusy/my_page.dart';
// import 'package:ebusy/services/http.dart';
// import 'package:ebusy/services/provider.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
//
// class CheckoutPage extends StatefulWidget {
//   final String? company;
//   final String? route;
//   final String? fare;
//   final String? time;
//   final String? date;
//   final String? booker;
//
//   const CheckoutPage({
//     Key? key,
//     required this.company,
//     required this.route,
//     required this.fare,
//     required this.time,
//     required this.date,
//     required this.booker,
//   }) : super(key: key);
//
//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }
//
// double usd = 0.00059;
// double mwk = 2000;
// double pay = usd * mwk;
// String transId = '';
//
// class _CheckoutPageState extends State<CheckoutPage> {
//   final ScreenshotController screenshotController = ScreenshotController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white10,
//         shadowColor: Colors.transparent,
//         foregroundColor: Colors.grey,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//         title: const Text(
//           "Bus Booking",
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.money),
//             SizedBox(height: 20),
//             Text("Proceed booking"),
//             SizedBox(height: 20),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (BuildContext context) => PaypalCheckout(
//                     sandboxMode: true,
//                     clientId:
//                         "AWvQYTFvdEAYzs_whD4jLbtGnHjyIKKlXkLCAz4v8BQjjVJEMvOA6XScSOrWrZb90WAzRYDoWsMH1qW6",
//                     secretKey:
//                         "EE95JQJVzIXUpHIJ3Nrvp7YyxEEd5SbkU8NMIhFo7CaQodbHjuJc-T5EvQ2iOxa9OMXfmk-cmrzWDlVn", // Replace with your PayPal secret key
//                     returnURL: "success.snippetcoder.com",
//                     cancelURL: "cancel.snippetcoder.com",
//                     transactions: [
//                       {
//                         "amount": {
//                           "total": "${pay.toStringAsFixed(2)}",
//                           "currency": "USD",
//                         },
//                         "description": "Bus booking fee.",
//                         "item_list": {
//                           "items": [
//                             {
//                               "name": "Company",
//                               "quantity": 1,
//                               "price": "${pay.toStringAsFixed(2)}",
//                               "currency": "USD"
//                             }
//                           ],
//                         }
//                       }
//                     ],
//                     note: "Contact us for any questions on your order.",
//                     onSuccess: (Map params) async {
//                       // Extract payment details
//                       transId = params['data']['id'];
//
//                       // Make an HTTP request to your PHP backend
//                       var response = await http.post(
//                         Uri.parse(
//                             "$url/buses/book.php"), // Replace with your actual backend URL
//                         body: {
//                           'company': widget.company,
//                           'route': widget.route,
//                           'fare': widget.fare,
//                           'time': widget.time,
//                           'date': widget.date,
//                           'booker': 'vgkv',
//                           'transid': transId,
//                         },
//                       );
//
//                       // Handle the response from the server as needed
//                       if (response.statusCode == 200) {
//                         if (response.body == 'Bus booked successfully!') {
//                           print('Appointment details stored successfully');
//                           MySnackBar(context,
//                               message: response.body, mcolor: Colors.green);
//                           Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => SuccessPage()));
//                         }
//                       } else {
//                         MySnackBar(context,
//                             message: response.body, mcolor: Colors.red);
//                         print(
//                             'Error storing appointment details: ${response.body}');
//                       }
//                       print("onSuccess: $params");
//                     },
//                     onError: (error) {
//                       MySnackBar(context, message: error, mcolor: Colors.red);
//                       print("onError: $error");
//
//                       Navigator.pop(context);
//                     },
//                     onCancel: () {
//                       MySnackBar(context,
//                           message: "Payment cancelled!", mcolor: Colors.blue);
//                       print('cancelled:');
//                     },
//                   ),
//                 ));
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.yellow,
//                 foregroundColor: Colors.black87,
//               ),
//               child: const Text('Pay with PayPal'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
