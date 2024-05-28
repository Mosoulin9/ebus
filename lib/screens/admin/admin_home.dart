import 'dart:convert';
import 'package:ebus/screens/admin/admin_buses.dart';
import 'package:ebus/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../provider.dart';
import '../customer/customer_profile.dart';
import 'admin_msg.dart';
import 'admin_tickets.dart';
import 'admin_users.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  GlobalKey<FormState> keys = GlobalKey<FormState>();
  GlobalKey<FormState> keys2 = GlobalKey<FormState>();
  GlobalKey<FormState> keys3 = GlobalKey<FormState>();
  TextEditingController cname = TextEditingController();
  TextEditingController license = TextEditingController();
  TextEditingController message = TextEditingController();
  TextEditingController message2 = TextEditingController();

  String? msgTotal;

  List indexPages = [
    AdminBus(),
    AdminTickets(),
    AdminUsers(),
  ];

  String selectedCompany = '';
  List<String> companiesz = [];

  @override
  void initState() {
    super.initState();

    getMsgTotal();
    getCompanyList();
  }

  Future<void> getMsgTotal() async {
    var res = await http
        .post(Uri.parse('$urla/sendnotification/activetsms.php'), body: {
      'admin': Provider.of<UserProvider>(context, listen: false).userFullname
    });
    if (res.statusCode == 200) {
      print(res.body);
      msgTotal = res.body;
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
          if (companyData.containsKey('company')) {
            companyNames.add(companyData['company']);
            print(companiesz.toString());
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

  String msgs = '0';

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
                          "Admin",
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
                          updateMsg('Admin');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminMsg()));
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
            padding: const EdgeInsets.only(top: 95.0, bottom: 10),
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
                                          Icons.people_alt_rounded,
                                          color: Color(0XFFbd5bae),
                                        ),
                                      ),
                                      Text(
                                        customers!,
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
                                "Customers",
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
                                        companies!,
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
                                        revenue!,
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
                                  "Add Bus Company",
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
                                        controller: cname,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Name",
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
                                        controller: license,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: "License Number",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                            prefixIcon: Icon(
                                              CupertinoIcons.bag_badge_plus,
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
                                          addCompany(context, cname.text,
                                              license.text);
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
                                  "Message a Company",
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
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 0.5),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color:
                                                Colors.white.withOpacity(0.3)),
                                        child: DropdownButtonFormField<String>(
                                          value: selectedCompany,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: Icon(
                                              CupertinoIcons.bus,
                                              color: Colors.grey[400],
                                            ),
                                            labelText: "Companies",
                                            labelStyle: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedCompany = newValue!;
                                            });
                                          },
                                          items: companiesz
                                              .map<DropdownMenuItem<String>>(
                                            (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (keys3.currentState!.validate()) {
                                          sendMessage(context, message2.text,
                                              'Admin', selectedCompany);
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
                                  "Send Notifications to all users",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Form(
                              key: keys2,
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
                                        controller: message,
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
                                              CupertinoIcons.bell_fill,
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
                                        if (keys2.currentState!.validate()) {
                                          sendNotification(
                                              context, message.text);
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
