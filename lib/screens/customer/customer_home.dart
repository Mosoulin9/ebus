import 'dart:convert';
import 'package:ebus/screens/Company/Company_buses.dart';
import 'package:ebus/screens/customer/customer_profile.dart';
import 'package:ebus/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../provider.dart';
import 'customer_customers.dart';
import 'customer_notif.dart';
import 'customer_tickets.dart';
import 'package:intl/intl.dart';
import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});
  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  GlobalKey<FormState> keys = GlobalKey<FormState>();
  GlobalKey<FormState> keys2 = GlobalKey<FormState>();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  GlobalKey<FormState> keys3 = GlobalKey<FormState>();
  TextEditingController route = TextEditingController();
  TextEditingController fare = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController capacity = TextEditingController();
  TextEditingController message2 = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  int? _ticketId;
  String? _routes;
  String? _fare;
  String? _seatNum;
  String? _company;
  String? _busId;
  String? _date;
  String? _time;
  String? _transId;
  String? _status;
  String? busesTotal;
  String? aTicketsTotal;
  String? notifTotal;

  List indexPages = [
    CompanyBus(),
    CustomerTickets(),
    CustomerCutsomers(),
  ];

  String selectedCompany = '';
  List<String> companiesz = [];

  String selectedRoute = '';
  List<String> routes = [];

  String selectedTime = '';
  List<String> times = [];

  @override
  void initState() {
    super.initState();
    getCompanyList();
    getRoutesList();
    getTimeList();
    getMsgTotal();
    getNotifTotal();
    fetchBuses();
    fetchTick();
    fetchBusesTotal();
    fetchActiveTicketsTotal();
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

  //get  buses total
  Future fetchBusesTotal() async {
    final response = await http.get(Uri.parse('$urla/buses/buses.php'));

    if (response.statusCode == 200) {
      print(response.body);
      busesTotal = response.body;
    } else {
      throw Exception('Failed to load buses');
    }
  }

  //get  active tickets total
  Future fetchActiveTicketsTotal() async {
    final response =
        await http.post(Uri.parse('$urla/buses/activets.php'), body: {
      'uid': Provider.of<UserProvider>(context, listen: false).userId,
    });

    if (response.statusCode == 200) {
      print(response.body);
      aTicketsTotal = response.body;
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

  Future<void> fetchTick() async {
    try {
      final response = await http.post(
        Uri.parse('$urla/buses/tick.php'),
        body: {'uid': Provider.of<UserProvider>(context, listen: false).userId},
      );

      if (response.statusCode == 200) {
        print(Provider.of<UserProvider>(context, listen: false).userId);
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        for (var res in jsonResponse) {
          Provider.of<UserProvider>(context, listen: false).setTicketDetails(
            res['id'].toString(),
            res['routes'],
            res['fare'],
            res['seat_num'],
            res['company'],
            res['bus_number'],
            res['date'],
            res['time'],
            res['transid'],
            res['status'],
            res['created'].toString(),
          );
        }
      } else {
        throw Exception(
            'Failed to load ticket. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occurred during the request or JSON decoding
      print('Error fetching ticket: $e');
    }
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

  Future<void> getCompanyList() async {
    var res = await http.get(Uri.parse('$urla/addcompany/getall.php'));
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      if (jsonData is List &&
          jsonData.isNotEmpty &&
          jsonData.first is Map<String, dynamic>) {
        List<String> companyNames = [];
        for (var companyData in jsonData) {
          if (companyData.containsKey('fullname')) {
            companyNames.add(companyData['fullname']);
          }
        }

        setState(() {
          companiesz = companyNames;
          selectedCompany = companiesz.isNotEmpty ? companiesz[0] : '';
        });
      } else {
        print('Invalid JSON format or empty response');
      }
    } else {
      print('Failed to fetch company list: ${res.statusCode}');
    }
  }

  Future<void> getRoutesList() async {
    var res = await http.get(Uri.parse('$urla/addcompany/getroute.php'));
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      if (jsonData is List &&
          jsonData.isNotEmpty &&
          jsonData.first is Map<String, dynamic>) {
        List<String> routesNames = [];
        for (var routesData in jsonData) {
          if (routesData.containsKey('route')) {
            routesNames.add(routesData['route']);
          }
        }

        setState(() {
          routes = routesNames;
          selectedRoute = routes.isNotEmpty ? routes[0] : '';
        });
      } else {
        print('Invalid JSON format or empty response');
      }
    } else {
      print('Failed to fetch routes list: ${res.statusCode}');
    }
  }

  Future<void> getTimeList() async {
    var res = await http.get(Uri.parse('$urla/addcompany/gettime.php'));
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      if (jsonData is List &&
          jsonData.isNotEmpty &&
          jsonData.first is Map<String, dynamic>) {
        List<String> timeNames = [];
        for (var timeData in jsonData) {
          if (timeData.containsKey('time')) {
            timeNames.add(timeData['time']);
          }
        }

        times = timeNames;
        selectedTime = times.isNotEmpty ? times[0] : '';
      } else {
        print('Invalid JSON format or empty response');
      }
    } else {
      print('Failed to fetch time list: ${res.statusCode}');
    }
  }

  String msgs = '0';
  String notif = '0';

  Future<void> getMsgTotal() async {
    var res = await http
        .post(Uri.parse('$urla/sendnotification/getmsgstotal.php'), body: {
      'uid': Provider.of<UserProvider>(context, listen: false).userId
    });
    if (res.statusCode == 200) {
      msgs = res.body.toString();

      // Display notification
      // await _showNotification();
    }
  }

  //
  Future<void> getNotifTotal() async {
    var res = await http.post(Uri.parse('$urla/sendnotification/activets.php'),
        body: {
          'uid': Provider.of<UserProvider>(context, listen: false).userEmail
        });
    if (res.statusCode == 200) {
      notifTotal = res.body;
      print(notif);
      // await _showNotification1();

      // Display notification
    }
  }

  // Future<void> _showNotification() async {
  //   // Initialize the plugin
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();
  //
  //   // Initialize settings for Android
  //   AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings(
  //           'ic_launcher.png'); // Replace app_icon with your icon name
  //   InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);
  //
  //   // Initialize the plugin
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  //
  //   // Define notification details
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'MSG_ID2',
  //     'Message Notifications 2',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   // Display the notification
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'New Message Received',
  //     'You have $msgs new messages.',
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  // }
  //
  // Future<void> _showNotification1() async {
  //   // Initialize the plugin
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();
  //
  //   // Initialize settings for Android
  //   AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings(
  //           'ic_launcher.png'); // Replace app_icon with your icon name
  //   InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);
  //
  //   // Initialize the plugin
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  //
  //   // Define notification details
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'MSG_ID1',
  //     'Message Notifications 1',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   // Display the notification
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'New Message Received',
  //     'You have $notif new messages.',
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  // }

  String? fName;

  @override
  Widget build(BuildContext context) {
    fName = Provider.of<UserProvider>(context, listen: false).userFullname;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "images/in.png",
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
            child: AppBar(
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 5, bottom: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerProfile()));
                  },
                  child: CircleAvatar(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      child: Text(fName!.substring(0, 2).toUpperCase())),
                ),
              ),
              title: Row(
                children: [
                  Container(
                    width: 90,
                    child: Text(
                      overflow: TextOverflow.fade,
                      Provider.of<UserProvider>(context, listen: false)
                          .userFullname
                          .toString(),
                      style: TextStyle(color: Color(0XFFe8e8e8)),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.3, color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 3),
                        child: Text(
                          "Customer",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ))
                ],
              ),
              actions: [
                Stack(
                  children: [
                    IconButton(
                        onPressed: () {
                          updateNotif(
                              Provider.of<UserProvider>(context, listen: false)
                                  .userEmail);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Notifications()));
                        },
                        icon: Icon(CupertinoIcons.bell_fill,
                            color: Color(0XFFe8e8e8))),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.white),
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.redAccent.shade700.withOpacity(0.7)),
                      child: Center(
                        child: Text(
                          notifTotal.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    )
                  ],
                ),
                IconButton(
                    onPressed: () {
                      logout(
                          context,
                          Provider.of<UserProvider>(context, listen: false)
                                  .userEmail ??
                              '');
                    },
                    icon: Icon(Icons.logout, color: Color(0XFFe8e8e8)))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 85.0, bottom: 10),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0XFFbd905b).withOpacity(0.25),
                                  border: Border.all(
                                      color: Color(0XFFbd905b), width: 0.5),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.5), // Faint shadow color
                                      spreadRadius: 2, // Spread radius
                                      blurRadius: 5, // Blur radius
                                      offset: Offset(
                                          0, 2), // Offset from the container
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 30),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Color(0XFFbd905b).withOpacity(0.3),
                                        child: Icon(
                                          CupertinoIcons.bus,
                                          color: Color(0XFFbd905b),
                                        ),
                                      ),
                                      Text(
                                        busesTotal.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Bus Companies",
                                style: TextStyle(color: Color(0XFFe8e8e8)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0XFF5bbd74).withOpacity(0.25),
                                  border: Border.all(
                                      color: Color(0XFF5bbd74), width: 0.5),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.5), // Faint shadow color
                                      spreadRadius: 2, // Spread radius
                                      blurRadius: 5, // Blur radius
                                      offset: Offset(
                                          0, 2), // Offset from the container
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 30),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Color(0XFF5bbd74).withOpacity(0.3),
                                        child: Icon(
                                          CupertinoIcons.tickets_fill,
                                          color: Color(0XFF5bbd74),
                                        ),
                                      ),
                                      Text(
                                        aTicketsTotal.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Active Tickets",
                                style: TextStyle(color: Color(0XFFe8e8e8)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Provider.of<UserProvider>(context, listen: false)
                                .ticketId !=
                            null
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0,
                                      vertical: 20,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                            'images/logo.png',
                                            height: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Scaffold(
                                                      body: Center(
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.4,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.4,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                BarcodeWidget(
                                                                  key:
                                                                      UniqueKey(), // Add a key to force the rebuild
                                                                  barcode: Barcode
                                                                      .qrCode(),
                                                                  data:
                                                                      '${Provider.of<UserProvider>(context, listen: false).ticketId.toString()}',
                                                                  width:
                                                                      150, // Adjust width as needed
                                                                  height: 150,
                                                                  color: Colors
                                                                      .yellow,
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  splashColor:
                                                                      Colors
                                                                          .black,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            70.0),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.yellowAccent,
                                                                            width: 0.5),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Color(0XFF3d4897),
                                                                            Color(0XFFbe5bad)
                                                                          ],
                                                                          begin:
                                                                              Alignment.topLeft,
                                                                          end: Alignment
                                                                              .bottomRight,
                                                                        ),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black.withOpacity(0.5), // Faint shadow color
                                                                            spreadRadius:
                                                                                2, // Spread radius
                                                                            blurRadius:
                                                                                5, // Blur radius
                                                                            offset:
                                                                                Offset(0, 2), // Offset from the container
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                60),
                                                                        child:
                                                                            Text(
                                                                          "Close",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: BarcodeWidget(
                                              key:
                                                  UniqueKey(), // Add a key to force the rebuild
                                              barcode: Barcode.qrCode(),
                                              data:
                                                  '${Provider.of<UserProvider>(context, listen: false).ticketId.toString()}',
                                              width:
                                                  50, // Adjust width as needed
                                              height: 50,
                                              color: Colors
                                                  .yellow, // Adjust height as needed
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Company:"),
                                              Text(Provider.of<UserProvider>(
                                                      context,
                                                      listen: false)
                                                  .company
                                                  .toString()),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Ticket#:"),
                                              Text(
                                                  '${Provider.of<UserProvider>(context, listen: false).ticketId.toString()}'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Customer:"),
                                              Text(
                                                  '${Provider.of<UserProvider>(context, listen: false).userFullname}'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Email:"),
                                              Text(
                                                  '${Provider.of<UserProvider>(context, listen: false).userEmail}'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Route:"),
                                              Text(
                                                  '${Provider.of<UserProvider>(context, listen: false).routes.toString()}'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Departure:"),
                                              Text(
                                                  '${Provider.of<UserProvider>(context, listen: false).time.toString()}'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Date:"),
                                              Text(
                                                  '${Provider.of<UserProvider>(context, listen: false).date.toString()}'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Fare (MWK):"),
                                              Text(
                                                  '${Provider.of<UserProvider>(context, listen: false).fare.toString()}'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Booked On:"),
                                              Text(
                                                  '${Provider.of<UserProvider>(context, listen: false).bookedOn.toString()}'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("TransID:"),
                                              Container(
                                                width: 180,
                                                child: Text(
                                                  '${Provider.of<UserProvider>(context, listen: false).transId.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Seat#:"),
                                              Text(
                                                  '${Provider.of<UserProvider>(context, listen: false).seatNum.toString()}'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Provider.of<UserProvider>(context,
                                                          listen: false)
                                                      .status ==
                                                  'Pending'
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Status:"),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.yellow,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Text(
                                                          '${Provider.of<UserProvider>(context, listen: false).status.toString()}',
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Status:"),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Text(
                                                          '${Provider.of<UserProvider>(context, listen: false).status.toString()}',
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Text(''),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Book a bus',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: key,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: FutureBuilder<List<Buses>>(
                          future: fetchBuses(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.hasData) {
                              final buses = snapshot.data!;
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                        buses.length,
                                        (index) {
                                          final bus = buses[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0, vertical: 10),
                                            child: Container(
                                              width:
                                                  250, // Adjust width as needed
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 0.5,
                                                    color:
                                                        Colors.purple.shade400),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor:
                                                              Colors.purple
                                                                  .withOpacity(
                                                                      0.25),
                                                          child: CircleAvatar(
                                                            child: Icon(
                                                              Icons
                                                                  .bus_alert_sharp,
                                                              color:
                                                                  Colors.purple,
                                                            ),
                                                            radius: 18,
                                                            backgroundColor:
                                                                Colors.purple
                                                                    .withOpacity(
                                                                        0.3),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    CupertinoIcons
                                                                        .bus,
                                                                    size: 14,
                                                                    color: Colors
                                                                        .grey),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                    bus.company
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white60)),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    CupertinoIcons
                                                                        .location_solid,
                                                                    size: 14,
                                                                    color: Colors
                                                                        .grey),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                    bus.route
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white60)),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    size: 14,
                                                                    color: Colors
                                                                        .grey),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                    bus.time
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white60)),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons.money,
                                                                    size: 14,
                                                                    color: Colors
                                                                        .grey),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                    bus.price
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white60)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Column(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: bus.status
                                                                            .toString() ==
                                                                        '0'
                                                                    ? Colors
                                                                        .green
                                                                        .withOpacity(
                                                                            0.2)
                                                                    : Colors.red
                                                                        .withOpacity(
                                                                            0.2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10.0,
                                                                        left:
                                                                            5),
                                                                child: Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius: 3,
                                                                      backgroundColor: bus.status.toString() ==
                                                                              '0'
                                                                          ? Colors
                                                                              .green
                                                                              .shade700
                                                                          : Colors
                                                                              .red
                                                                              .shade700,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            2),
                                                                    Text(
                                                                      bus.status.toString() ==
                                                                              '0'
                                                                          ? "Available"
                                                                          : "Unavailable",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color: bus.status.toString() == '0'
                                                                              ? Colors.green.shade400
                                                                              : Colors.red.shade400),
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
                                                    bus.status.toString() == '0'
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        3),
                                                            child: Container(
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 0.5),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        2,
                                                                    blurRadius:
                                                                        5,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2),
                                                                  ),
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.3),
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                      .isEmpty) {
                                                                    return 'Choose date';
                                                                  } else {
                                                                    return null;
                                                                  }
                                                                },
                                                                controller:
                                                                    _dateController, // Make sure _dateController is initialized
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Choose date',
                                                                  hintStyle: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .calendar_today,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                onTap: () =>
                                                                    _showDatePicker(
                                                                        context),
                                                              ),
                                                            ))
                                                        : Text(''),
                                                    bus.status.toString() == '0'
                                                        ? SizedBox(height: 10)
                                                        : Text(''),
                                                    // Booking button
                                                    bus.status.toString() == '0'
                                                        ? InkWell(
                                                            onTap: () {
                                                              if (key
                                                                  .currentState!
                                                                  .validate()) {
                                                                book(
                                                                    context,
                                                                    bus.id
                                                                        .toString(),
                                                                    bus.company
                                                                        .toString(),
                                                                    bus.route
                                                                        .toString(),
                                                                    bus.time
                                                                        .toString(),
                                                                    bus.price
                                                                        .toString(),
                                                                    _dateController
                                                                        .text);
                                                              }
                                                            },
                                                            splashColor:
                                                                Colors.black,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          3),
                                                              child: Container(
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                          width:
                                                                              0.5),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          2,
                                                                      blurRadius:
                                                                          5,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              2),
                                                                    ),
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    'Book',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        3),
                                                            child: Container(
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                        width:
                                                                            0.5),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        2,
                                                                    blurRadius:
                                                                        5,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2),
                                                                  ),
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Bus is Full',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
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
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: Text('No buses available'),
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tickets {
  String? id;
  String? company;
  String? route;
  String? time;
  String? date;
  String? price;
  String? status;

  Tickets({
    required this.id,
    required this.company,
    required this.route,
    required this.time,
    required this.date,
    required this.price,
    required this.status,
  });

  Tickets.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        company = json['company'].toString(),
        route = json['routes'].toString(),
        time = json['time'].toString(),
        date = json['date'].toString(),
        price = json['fare'].toString(),
        status = json['status'].toString();
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
