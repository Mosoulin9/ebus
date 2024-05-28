import 'dart:convert';
import 'package:ebus/provider.dart';
import 'package:ebus/screens/customer/customer_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services.dart';

class CompanyBus extends StatefulWidget {
  const CompanyBus({super.key});

  @override
  State<CompanyBus> createState() => _CompanyBusState();
}

class _CompanyBusState extends State<CompanyBus> {
  final TextEditingController _dateController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchBuses();
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<List<Buses>> fetchBuses() async {
    final response = await http.get(Uri.parse('$urla/buses/getall.php'));

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Buses.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load buses');
    }
  }

  Future<void> book(
      BuildContext context, id, company, route, time, price, date) async {
    // Convert date parameter to DateTime object
    DateTime bookingDate = DateTime.parse(date);
    // double usd = 1;
    // double mwk = 1733.50;
    // double priceAsDouble = double.parse(price as String);
    // double pay = (mwk / priceAsDouble) * usd;

    DateTime today = DateTime.now();
    if (bookingDate.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5), // Faint shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(0, 2), // Offset from the container
              ),
            ],
            borderRadius: BorderRadius.circular(5),
            color: Colors.red.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    'Invalid date!',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    } else {
      var res = await http.post(Uri.parse('$urla/users/chebus.php'), body: {
        'bus': company,
        'route': route,
        'time': time,
        'date': date,
      });

      if (res.statusCode == 200) {
        print(res.body);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => PaypalCheckout(
            sandboxMode: true,
            clientId:
                "AWvQYTFvdEAYzs_whD4jLbtGnHjyIKKlXkLCAz4v8BQjjVJEMvOA6XScSOrWrZb90WAzRYDoWsMH1qW6",
            secretKey:
                "EE95JQJVzIXUpHIJ3Nrvp7YyxEEd5SbkU8NMIhFo7CaQodbHjuJc-T5EvQ2iOxa9OMXfmk-cmrzWDlVn", // Replace with your PayPal secret key
            returnURL: "success.snippetcoder.com",
            cancelURL: "cancel.snippetcoder.com",
            transactions: [
              {
                "amount": {
                  "total": price,
                  "currency": "USD",
                },
                "description": "Bus booking fee.",
                "item_list": {
                  "items": [
                    {
                      "name": "Company",
                      "quantity": 1,
                      "price": price,
                      "currency": "USD"
                    }
                  ],
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              // Extract payment details
              var transId = params['data']['id'];

              // Make an HTTP request to your PHP backend
              var response = await http.post(
                Uri.parse(
                    "$urla/buses/book.php"), // Replace with your actual backend URL
                body: {
                  'company': company,
                  'busid': id,
                  'route': route,
                  'fare': price,
                  'time': time,
                  'date': date,
                  'booker':
                      Provider.of<UserProvider>(context, listen: false).userId,
                  'transid': transId,
                },
              );

              // Handle the response from the server as needed
              if (response.statusCode == 200) {
                if (response.body == 'Bus booked successfully!') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      showCloseIcon: true,
                      backgroundColor: Colors.transparent,
                      content: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.5), // Faint shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 5, // Blur radius
                                offset:
                                    Offset(0, 2), // Offset from the container
                              ),
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.green.withOpacity(0.1)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 15,
                                color: Colors.green,
                              ),
                              Text(
                                response.body,
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          )),
                        ),
                      )));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CustomerHome()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      showCloseIcon: true,
                      backgroundColor: Colors.transparent,
                      content: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.5), // Faint shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 5, // Blur radius
                                offset:
                                    Offset(0, 2), // Offset from the container
                              ),
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.red.withOpacity(0.1)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 15,
                                color: Colors.red,
                              ),
                              Text(
                                response.body,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          )),
                        ),
                      )));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    showCloseIcon: true,
                    backgroundColor: Colors.transparent,
                    content: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.5), // Faint shadow color
                              spreadRadius: 2, // Spread radius
                              blurRadius: 5, // Blur radius
                              offset: Offset(0, 2), // Offset from the container
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.red.withOpacity(0.1)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 15,
                              color: Colors.red,
                            ),
                            Text(
                              response.body,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        )),
                      ),
                    )));
              }
              print("onSuccess: $params");
            },
            onError: (error) {},
            onCancel: () {},
          ),
        ));
      } else {
        print(res.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.transparent,
            content: Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.5), // Faint shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 2), // Offset from the container
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red.withOpacity(0.1)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 15,
                      color: Colors.red,
                    ),
                    Text(
                      res.body,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )),
              ),
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "images/in.png",
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
              ],
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  CupertinoIcons.bus,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "Buses List",
                style: TextStyle(color: Color(0XFFe8e8e8)),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: Form(
                key: key,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: FutureBuilder<List<Buses>>(
                    future: fetchBuses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        final items = snapshot.data!;
                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, index) {
                            var item = items[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 10,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors.purple.shade400,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      // Bus details
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                Colors.purple.withOpacity(0.25),
                                            child: CircleAvatar(
                                              child: Icon(
                                                Icons.bus_alert_sharp,
                                                color: Colors.purple,
                                              ),
                                              radius: 18,
                                              backgroundColor: Colors.purple
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Bus company
                                              Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.bus,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    item.company.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white60),
                                                  ),
                                                ],
                                              ),
                                              // Bus route
                                              Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons
                                                        .location_solid,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    item.route.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white60),
                                                  ),
                                                ],
                                              ),
                                              // Bus time
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    item.time
                                                        .toString(), // Should be item.time!
                                                    style: TextStyle(
                                                        color: Colors.white60),
                                                  ),
                                                ],
                                              ),
                                              // Bus price
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.money,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    item.price.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white60),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Column(
                                            children: [
                                              // Bus availability status
                                              item.status.toString() == '0'
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 10.0,
                                                          left: 5,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 3,
                                                              backgroundColor:
                                                                  Colors.green
                                                                      .shade700,
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              'Available',
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .green
                                                                    .shade400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.red
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 10.0,
                                                          left: 5,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 3,
                                                              backgroundColor:
                                                                  Colors.red
                                                                      .shade700,
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              'Unavailable',
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .red
                                                                    .shade400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 5),
                                      // Date selection
                                      item.status.toString() == '0'
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 0.5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                ),
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Choose date';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  controller:
                                                      _dateController, // Make sure _dateController is initialized
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                  decoration: InputDecoration(
                                                    hintText: 'Choose date',
                                                    hintStyle: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white),
                                                    border: InputBorder.none,
                                                    prefixIcon: Icon(
                                                      Icons.calendar_today,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onTap: () =>
                                                      _showDatePicker(context),
                                                ),
                                              ))
                                          : Text(''),
                                      item.status.toString() == '0'
                                          ? SizedBox(height: 10)
                                          : Text(''),
                                      // Booking button
                                      item.status.toString() == '0'
                                          ? InkWell(
                                              onTap: () {
                                                if (key.currentState!
                                                    .validate()) {
                                                  book(
                                                      context,
                                                      item.id.toString(),
                                                      item.company.toString(),
                                                      item.route.toString(),
                                                      item.time.toString(),
                                                      item.price.toString(),
                                                      _dateController.text);
                                                }
                                              },
                                              splashColor: Colors.black,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3),
                                                child: Container(
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    border:
                                                        Border.all(width: 0.5),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.blue,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Book',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  border:
                                                      Border.all(width: 0.5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.red,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Bus is Full',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class Buses {
  String? id;
  String? company;
  String? route;
  String? time;
  String? price;
  String? status;

  Buses({
    required this.id,
    required this.company,
    required this.route,
    required this.time,
    required this.price,
    required this.status,
  });

  Buses.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        company = json['company'].toString(),
        route = json['route'].toString(),
        time = json['time'].toString(),
        price = json['fare'].toString(),
        status = json['full'].toString();
}
