import 'dart:convert';
import 'package:ebus/provider.dart';
import 'package:ebus/screens/admin/admin_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services.dart';
import '../company/company_bottom.dart';
import 'customer_bottom.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchBuses();
  }

  Future<List<Tickets>> fetchBuses() async {
    final response =
        await http.post(Uri.parse('$urla/buses/mynotif.php'), body: {
      'uid': Provider.of<UserProvider>(context, listen: false).userEmail,
    });

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Tickets.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications');
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
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      if (Provider.of<UserProvider>(context, listen: false)
                              .userRole ==
                          'Admin') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNav(index: 0)));
                      } else if (Provider.of<UserProvider>(context,
                                  listen: false)
                              .userRole ==
                          'Company') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CompanyBottomNav(index: 0)));
                      } else if (Provider.of<UserProvider>(context,
                                  listen: false)
                              .userRole ==
                          'Customer') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomerBottomNav(index: 0)));
                      } else {}
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
              title: Text(
                "Profile",
                style: TextStyle(color: Color(0XFFe8e8e8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        child: Text(
                          Provider.of<UserProvider>(context, listen: false)
                              .userFullname
                              .toString()
                              .substring(0, 2)
                              .toUpperCase(),
                          style: TextStyle(fontSize: 60),
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 0.5, color: Colors.lightBlueAccent)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 3),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        Provider.of<UserProvider>(context,
                                                listen: true)
                                            .userFullname
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Provider.of<UserProvider>(context, listen: true)
                                              .userRole
                                              .toString() ==
                                          'Company' ||
                                      Provider.of<UserProvider>(context,
                                                  listen: true)
                                              .userRole
                                              .toString() ==
                                          'Admin'
                                  ? Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.yellow
                                                  .withOpacity(0.1),
                                              size: 15,
                                            ))
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
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
                                                                .withOpacity(
                                                                    0.7),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Form(
                                                            key: key,
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            25.0),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Text(
                                                                        'Update name',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.yellow),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 50,
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              25),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            30,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Colors.white,
                                                                              width: 0.5),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black.withOpacity(0.5),
                                                                              spreadRadius: 2,
                                                                              blurRadius: 5,
                                                                              offset: Offset(0, 2),
                                                                            ),
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.3),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                          ),
                                                                          child:
                                                                              TextFormField(
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'Required!';
                                                                              } else if (value.length < 3) {
                                                                                return 'Name hould be 3 characters long!';
                                                                              } else {
                                                                                return null;
                                                                              }
                                                                            },
                                                                            controller:
                                                                                name, // Make sure _dateController is initialized
                                                                            style:
                                                                                TextStyle(color: Colors.grey),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              hintText: 'Name',
                                                                              hintStyle: TextStyle(fontSize: 12, color: Colors.white),
                                                                              border: InputBorder.none,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            25.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (key.currentState!.validate()) {
                                                                              updateName(context, name.text);
                                                                              Navigator.pop(context);
                                                                            }
                                                                          },
                                                                          splashColor:
                                                                              Colors.black,
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(color: Colors.yellowAccent, width: 0.5),
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
                                                                                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                                                                                  spreadRadius: 2, // Spread radius
                                                                                  blurRadius: 5, // Blur radius
                                                                                  offset: Offset(0, 2), // Offset from the container
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                                                                              child: Text(
                                                                                "Ok",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          splashColor:
                                                                              Colors.black,
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(color: Colors.yellowAccent, width: 0.5),
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              gradient: LinearGradient(
                                                                                colors: [
                                                                                  Color(0XFF3d4897).withOpacity(0.4),
                                                                                  Colors.red
                                                                                ],
                                                                                begin: Alignment.topRight,
                                                                                end: Alignment.bottomLeft,
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                                                                                  spreadRadius: 2, // Spread radius
                                                                                  blurRadius: 5, // Blur radius
                                                                                  offset: Offset(0, 2), // Offset from the container
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                                                                              child: Text(
                                                                                "Back",
                                                                                style: TextStyle(color: Colors.white),
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
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.yellow,
                                              size: 15,
                                            ))
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 0.5, color: Colors.lightBlueAccent)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 3),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.envelope_fill,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        Provider.of<UserProvider>(context,
                                                listen: true)
                                            .userEmail
                                            .toString()
                                            .toLowerCase(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.yellow.withOpacity(0.1),
                                        size: 15,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 0.5, color: Colors.lightBlueAccent)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 3),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        Provider.of<UserProvider>(context,
                                                listen: true)
                                            .userPhone
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Scaffold(
                                                body: Center(
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Form(
                                                      key: key,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          25.0),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  'Update Phone number',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .yellow),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 50,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            25),
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white,
                                                                        width:
                                                                            0.5),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.5),
                                                                        spreadRadius:
                                                                            2,
                                                                        blurRadius:
                                                                            5,
                                                                        offset: Offset(
                                                                            0,
                                                                            2),
                                                                      ),
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.3),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                    ),
                                                                    child:
                                                                        TextFormField(
                                                                      validator:
                                                                          (value) {
                                                                        if (value!
                                                                            .isEmpty) {
                                                                          return 'Required!';
                                                                        } else if (value.length !=
                                                                            10) {
                                                                          return 'Phone number should be 10 digits long!';
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                      controller:
                                                                          name, // Make sure _dateController is initialized
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Phone Number',
                                                                        hintStyle: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.white),
                                                                        border:
                                                                            InputBorder.none,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          25.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (key
                                                                          .currentState!
                                                                          .validate()) {
                                                                        updatePhone(
                                                                            context,
                                                                            name.text);
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    splashColor:
                                                                        Colors
                                                                            .black,
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
                                                                                40),
                                                                        child:
                                                                            Text(
                                                                          "Ok",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
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
                                                                            Color(0XFF3d4897).withOpacity(0.4),
                                                                            Colors.red
                                                                          ],
                                                                          begin:
                                                                              Alignment.topRight,
                                                                          end: Alignment
                                                                              .bottomLeft,
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
                                                                                40),
                                                                        child:
                                                                            Text(
                                                                          "Back",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
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
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.yellow,
                                        size: 15,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 0.5, color: Colors.lightBlueAccent)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 3),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_city,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        Provider.of<UserProvider>(context,
                                                listen: true)
                                            .userCity
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Scaffold(
                                                body: Center(
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Form(
                                                      key: key,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          25.0),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  'Update City',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .yellow),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 50,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            25),
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white,
                                                                        width:
                                                                            0.5),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.5),
                                                                        spreadRadius:
                                                                            2,
                                                                        blurRadius:
                                                                            5,
                                                                        offset: Offset(
                                                                            0,
                                                                            2),
                                                                      ),
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.3),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                    ),
                                                                    child:
                                                                        TextFormField(
                                                                      validator:
                                                                          (value) {
                                                                        if (value!
                                                                            .isEmpty) {
                                                                          return 'Required!';
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                      controller:
                                                                          name, // Make sure _dateController is initialized
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'City',
                                                                        hintStyle: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.white),
                                                                        border:
                                                                            InputBorder.none,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          25.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (key
                                                                          .currentState!
                                                                          .validate()) {
                                                                        updateCity(
                                                                            context,
                                                                            name.text);
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    splashColor:
                                                                        Colors
                                                                            .black,
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
                                                                                40),
                                                                        child:
                                                                            Text(
                                                                          "Ok",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
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
                                                                            Color(0XFF3d4897).withOpacity(0.4),
                                                                            Colors.red
                                                                          ],
                                                                          begin:
                                                                              Alignment.topRight,
                                                                          end: Alignment
                                                                              .bottomLeft,
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
                                                                                40),
                                                                        child:
                                                                            Text(
                                                                          "Back",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
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
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.yellow,
                                        size: 15,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 0.5, color: Colors.lightBlueAccent)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 3),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Password',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Scaffold(
                                                body: Center(
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Form(
                                                      key: key,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          25.0),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  'Enter Current Password',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .yellow),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 50,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            25),
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white,
                                                                        width:
                                                                            0.5),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.5),
                                                                        spreadRadius:
                                                                            2,
                                                                        blurRadius:
                                                                            5,
                                                                        offset: Offset(
                                                                            0,
                                                                            2),
                                                                      ),
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.3),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                    ),
                                                                    child:
                                                                        TextFormField(
                                                                      validator:
                                                                          (value) {
                                                                        if (value!
                                                                            .isEmpty) {
                                                                          return 'Required!';
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                      controller:
                                                                          name, // Make sure _dateController is initialized
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Password',
                                                                        hintStyle: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.white),
                                                                        border:
                                                                            InputBorder.none,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          25.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (key
                                                                          .currentState!
                                                                          .validate()) {
                                                                        checkPass(
                                                                            context,
                                                                            name.text);
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    splashColor:
                                                                        Colors
                                                                            .black,
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
                                                                                40),
                                                                        child:
                                                                            Text(
                                                                          "Ok",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
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
                                                                            Color(0XFF3d4897).withOpacity(0.4),
                                                                            Colors.red
                                                                          ],
                                                                          begin:
                                                                              Alignment.topRight,
                                                                          end: Alignment
                                                                              .bottomLeft,
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
                                                                                40),
                                                                        child:
                                                                            Text(
                                                                          "Back",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
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
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.yellow,
                                        size: 15,
                                      ))
                                ],
                              ),
                            ],
                          ),
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

class Tickets {
  String? id;
  String? message;
  String? email;
  String? status;
  String? created;

  Tickets({
    required this.id,
    required this.message,
    required this.email,
    required this.status,
    required this.created,
  });

  Tickets.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        message = json['message'].toString(),
        email = json['email'].toString(),
        status = json['status'].toString(),
        created = json['created'].toString();
}
