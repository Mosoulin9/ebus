import 'dart:convert';
import 'package:ebus/screens/Company/Company_buses.dart';
import 'package:ebus/screens/company/company_msg.dart';
import 'package:ebus/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../provider.dart';
import '../../qrscanner.dart';
import '../customer/customer_notif.dart';
import '../customer/customer_profile.dart';
import 'company_notif.dart';
import 'company_tickets.dart';
import 'company_customers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});
  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  GlobalKey<FormState> keys = GlobalKey<FormState>();
  GlobalKey<FormState> keys2 = GlobalKey<FormState>();
  GlobalKey<FormState> keys3 = GlobalKey<FormState>();
  TextEditingController route = TextEditingController();
  TextEditingController fare = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController capacity = TextEditingController();
  TextEditingController message2 = TextEditingController();

  String? busesTotal;
  String? aTicketsTotal;
  String? notifTotal;
  String? msgTotal;
  String? customersTotal;
  String? revenueTotal;

  List indexPages = [
    CompanyBus(),
    CompanyTickets(),
    CompanyCutsomers(),
  ];

  String selectedCompany = '';
  List<String> companiesz = [];

  @override
  void initState() {
    super.initState();
    getCompanyList();
    getNotifTotal();
    getMsgTotal();
    getCustomersTotal();
    getRevenueTotal();
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
          if (companyData.containsKey('company')) {
            companyNames.add(companyData['company']);
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

  Future<void> getNotifTotal() async {
    var res = await http.post(Uri.parse('$urla/sendnotification/activets.php'),
        body: {
          'uid': Provider.of<UserProvider>(context, listen: false).userEmail
        });
    if (res.statusCode == 200) {
      notifTotal = res.body;
      // await _showNotification1();

      // Display notification
    }
  }

  Future<void> getCustomersTotal() async {
    var res = await http.post(Uri.parse('$urla/buses/customers.php'), body: {
      'uid': Provider.of<UserProvider>(context, listen: false).userFullname
    });
    if (res.statusCode == 200) {
      print(res.body);
      customersTotal = res.body;
      // await _showNotification1();

      // Display notification
    }
  }

  Future<void> getRevenueTotal() async {
    var res = await http.post(Uri.parse('$urla/buses/customers.php'), body: {
      'revenue': Provider.of<UserProvider>(context, listen: false).userFullname
    });
    if (res.statusCode == 200) {
      print(res.body);
      revenueTotal = res.body;
      // await _showNotification1();

      // Display notification
    }
  }

  Future<void> getMsgTotal() async {
    var res = await http
        .post(Uri.parse('$urla/sendnotification/activetsms.php'), body: {
      'uid': Provider.of<UserProvider>(context, listen: false).userFullname
    });
    if (res.statusCode == 200) {
      msgTotal = res.body;
      // await _showNotification1();

      // Display notification
    }
  }

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
                    width: 60,
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
                          "Company",
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
                                  builder: (context) =>
                                      CompanyNotifications()));
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
                Stack(
                  children: [
                    IconButton(
                        onPressed: () {
                          updateMsg(
                              Provider.of<UserProvider>(context, listen: false)
                                  .userFullname);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CompanyMsg()));
                        },
                        icon: Icon(CupertinoIcons.envelope_fill,
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
                          msgTotal.toString(),
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
                                  color: Color(0XFFbd5bae).withOpacity(0.25),
                                  border: Border.all(
                                      color: Color(0XFFbd5bae), width: 0.5),
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
                                            Color(0XFFbd5bae).withOpacity(0.3),
                                        child: Icon(
                                          CupertinoIcons.tickets_fill,
                                          color: Color(0XFFbd5bae),
                                        ),
                                      ),
                                      Text(
                                        customersTotal ?? '0',
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
                                "All Tickets",
                                style: TextStyle(color: Color(0XFFe8e8e8)),
                              )
                            ],
                          ),
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
                                        buscompanies ?? '0',
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
                                "Buses",
                                style: TextStyle(color: Color(0XFFe8e8e8)),
                              )
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
                                          CupertinoIcons
                                              .money_dollar_circle_fill,
                                          color: Color(0XFF5bbd74),
                                        ),
                                      ),
                                      Text(
                                        revenueTotal ?? '0',
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
                                "Revenue(MWK)",
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 0.5, color: Colors.lightBlueAccent)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Clear Tickets",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20.0, right: 20, left: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QRViewExample()));
                                },
                                splashColor: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0XFF3d4897),
                                          Color(0XFFbe5bad)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Faint shadow color
                                          spreadRadius: 2, // Spread radius
                                          blurRadius: 5, // Blur radius
                                          offset: Offset(0,
                                              2), // Offset from the container
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.qr_code,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Scan",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Add a Bus",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Form(
                              key: keys,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.5), // Faint shadow color
                                              spreadRadius: 2, // Spread radius
                                              blurRadius: 5, // Blur radius
                                              offset: Offset(0,
                                                  2), // Offset from the container
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.white, width: 0.5),
                                          color: Colors.white.withOpacity(0.3)),
                                      child: TextFormField(
                                        controller: route,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Route",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            prefixIcon: Icon(
                                              Icons.add_road_rounded,
                                              color: Colors.grey[400],
                                            ),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.5), // Faint shadow color
                                              spreadRadius: 2, // Spread radius
                                              blurRadius: 5, // Blur radius
                                              offset: Offset(0,
                                                  2), // Offset from the container
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.white, width: 0.5),
                                          color: Colors.white.withOpacity(0.3)),
                                      child: TextFormField(
                                        controller: fare,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Fare",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            prefixIcon: Icon(
                                              Icons.money,
                                              color: Colors.grey[400],
                                            ),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 0.5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.5), // Faint shadow color
                                              spreadRadius: 2, // Spread radius
                                              blurRadius: 5, // Blur radius
                                              offset: Offset(0,
                                                  2), // Offset from the container
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white.withOpacity(0.3)),
                                      child: TextFormField(
                                        controller: time,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Time",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            prefixIcon: Icon(
                                              CupertinoIcons.time_solid,
                                              color: Colors.grey[400],
                                            ),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 0.5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.5), // Faint shadow color
                                              spreadRadius: 2, // Spread radius
                                              blurRadius: 5, // Blur radius
                                              offset: Offset(0,
                                                  2), // Offset from the container
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white.withOpacity(0.3)),
                                      child: TextFormField(
                                        controller: capacity,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Capacity",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            prefixIcon: Icon(
                                              CupertinoIcons.bus,
                                              color: Colors.grey[400],
                                            ),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (keys.currentState!.validate()) {
                                          addABusCompany(
                                              context,
                                              route.text,
                                              fare.text,
                                              time.text,
                                              capacity.text);
                                        }
                                      },
                                      splashColor: Colors.black,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0XFF3d4897),
                                                Color(0XFFbe5bad)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.5), // Faint shadow color
                                                spreadRadius:
                                                    2, // Spread radius
                                                blurRadius: 5, // Blur radius
                                                offset: Offset(0,
                                                    2), // Offset from the container
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 88),
                                            child: Text(
                                              "Add",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Message an Administrator",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Form(
                              key: keys3,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 0.5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.5), // Faint shadow color
                                              spreadRadius: 2, // Spread radius
                                              blurRadius: 5, // Blur radius
                                              offset: Offset(0,
                                                  2), // Offset from the container
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white.withOpacity(0.3)),
                                      child: TextFormField(
                                        controller: message2,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Message",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            prefixIcon: Icon(
                                              CupertinoIcons.envelope_fill,
                                              color: Colors.grey[400],
                                            ),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (keys3.currentState!.validate()) {
                                          sendMessageAdmin(
                                            context,
                                            message2.text,
                                          );
                                        }
                                      },
                                      splashColor: Colors.black,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0XFF3d4897),
                                                Color(0XFFbe5bad)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.5), // Faint shadow color
                                                spreadRadius:
                                                    2, // Spread radius
                                                blurRadius: 5, // Blur radius
                                                offset: Offset(0,
                                                    2), // Offset from the container
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 88),
                                            child: Text(
                                              "Send",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
