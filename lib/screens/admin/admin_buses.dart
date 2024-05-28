import 'dart:convert';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider.dart';
import '../../services.dart';

class AdminBus extends StatefulWidget {
  const AdminBus({super.key});

  @override
  State<AdminBus> createState() => _AdminBusState();
}

class _AdminBusState extends State<AdminBus> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchBuses();
  }

  Future<List<Tickets>> fetchBuses() async {
    final response =
        await http.post(Uri.parse('$urla/buses/mybuses.php'), body: {
      'admin': 'Provider.of<UserProvider>(context, listen: false).userFullname',
    });

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Tickets.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load buses');
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
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder<List<Tickets>>(
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
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 25.0,
                                                      vertical: 20,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Image.asset(
                                                            'images/logo.png',
                                                            height: 15,
                                                          ),
                                                          Icon(
                                                            CupertinoIcons.bus,
                                                            color:
                                                                Colors.yellow,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0),
                                                      child: Column(children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("Bus ID:"),
                                                            Text(item.id
                                                                .toString()),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Text("Route:"),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(item
                                                                        .route
                                                                        .toString()),
                                                                    item.full.toString() ==
                                                                            '1'
                                                                        ? Text(
                                                                            '')
                                                                        : IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return Scaffold(
                                                                                      body: Center(
                                                                                        child: Container(
                                                                                          height: MediaQuery.of(context).size.height * 0.4,
                                                                                          width: MediaQuery.of(context).size.height * 0.4,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors.black.withOpacity(0.7),
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: Form(
                                                                                            key: key,
                                                                                            child: Center(
                                                                                              child: Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 25.0),
                                                                                                    child: Align(
                                                                                                      alignment: Alignment.topLeft,
                                                                                                      child: Text(
                                                                                                        'Update Route',
                                                                                                        style: TextStyle(color: Colors.yellow),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 50,
                                                                                                  ),
                                                                                                  Padding(
                                                                                                      padding: EdgeInsets.symmetric(horizontal: 25),
                                                                                                      child: Container(
                                                                                                        height: 30,
                                                                                                        decoration: BoxDecoration(
                                                                                                          border: Border.all(color: Colors.white, width: 0.5),
                                                                                                          boxShadow: [
                                                                                                            BoxShadow(
                                                                                                              color: Colors.black.withOpacity(0.5),
                                                                                                              spreadRadius: 2,
                                                                                                              blurRadius: 5,
                                                                                                              offset: Offset(0, 2),
                                                                                                            ),
                                                                                                          ],
                                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                                          color: Colors.white.withOpacity(0.3),
                                                                                                        ),
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.symmetric(
                                                                                                            horizontal: 8.0,
                                                                                                          ),
                                                                                                          child: TextFormField(
                                                                                                            validator: (value) {
                                                                                                              if (value!.isEmpty) {
                                                                                                                return 'Required!';
                                                                                                              } else {
                                                                                                                return null;
                                                                                                              }
                                                                                                            },
                                                                                                            controller: name, // Make sure _dateController is initialized
                                                                                                            style: TextStyle(color: Colors.grey),
                                                                                                            decoration: InputDecoration(
                                                                                                              hintText: 'Route',
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
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        InkWell(
                                                                                                          onTap: () {
                                                                                                            if (key.currentState!.validate()) {
                                                                                                              editRoute(context, name.text, item.id.toString());
                                                                                                              Navigator.pop(context);
                                                                                                            }
                                                                                                          },
                                                                                                          splashColor: Colors.black,
                                                                                                          child: Container(
                                                                                                            decoration: BoxDecoration(
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
                                                                                                            child: Padding(
                                                                                                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                                                                                                              child: Text(
                                                                                                                "Ok",
                                                                                                                style: TextStyle(color: Colors.white),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        InkWell(
                                                                                                          onTap: () {
                                                                                                            Navigator.pop(context);
                                                                                                          },
                                                                                                          splashColor: Colors.black,
                                                                                                          child: Container(
                                                                                                            decoration: BoxDecoration(
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
                                                                                                            child: Padding(
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
                                                                            icon:
                                                                                Icon(
                                                                              Icons.edit,
                                                                              size: 13,
                                                                            )),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Text("Fare(MWK):"),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(item
                                                                        .fare
                                                                        .toString()),
                                                                    item.full.toString() ==
                                                                            '1'
                                                                        ? Text(
                                                                            '')
                                                                        : IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return Scaffold(
                                                                                      body: Center(
                                                                                        child: Container(
                                                                                          height: MediaQuery.of(context).size.height * 0.4,
                                                                                          width: MediaQuery.of(context).size.height * 0.4,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors.black.withOpacity(0.7),
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: Form(
                                                                                            key: key,
                                                                                            child: Center(
                                                                                              child: Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 25.0),
                                                                                                    child: Align(
                                                                                                      alignment: Alignment.topLeft,
                                                                                                      child: Text(
                                                                                                        'Update Fare',
                                                                                                        style: TextStyle(color: Colors.yellow),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 50,
                                                                                                  ),
                                                                                                  Padding(
                                                                                                      padding: EdgeInsets.symmetric(horizontal: 25),
                                                                                                      child: Container(
                                                                                                        height: 30,
                                                                                                        decoration: BoxDecoration(
                                                                                                          border: Border.all(color: Colors.white, width: 0.5),
                                                                                                          boxShadow: [
                                                                                                            BoxShadow(
                                                                                                              color: Colors.black.withOpacity(0.5),
                                                                                                              spreadRadius: 2,
                                                                                                              blurRadius: 5,
                                                                                                              offset: Offset(0, 2),
                                                                                                            ),
                                                                                                          ],
                                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                                          color: Colors.white.withOpacity(0.3),
                                                                                                        ),
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.symmetric(
                                                                                                            horizontal: 8.0,
                                                                                                          ),
                                                                                                          child: TextFormField(
                                                                                                            validator: (value) {
                                                                                                              if (value!.isEmpty) {
                                                                                                                return 'Required!';
                                                                                                              } else {
                                                                                                                return null;
                                                                                                              }
                                                                                                            },
                                                                                                            controller: name, // Make sure _dateController is initialized
                                                                                                            style: TextStyle(color: Colors.grey),
                                                                                                            decoration: InputDecoration(
                                                                                                              hintText: 'Fare',
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
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        InkWell(
                                                                                                          onTap: () {
                                                                                                            if (key.currentState!.validate()) {
                                                                                                              editFare(context, name.text, item.id.toString());
                                                                                                              Navigator.pop(context);
                                                                                                            }
                                                                                                          },
                                                                                                          splashColor: Colors.black,
                                                                                                          child: Container(
                                                                                                            decoration: BoxDecoration(
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
                                                                                                            child: Padding(
                                                                                                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                                                                                                              child: Text(
                                                                                                                "Ok",
                                                                                                                style: TextStyle(color: Colors.white),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        InkWell(
                                                                                                          onTap: () {
                                                                                                            Navigator.pop(context);
                                                                                                          },
                                                                                                          splashColor: Colors.black,
                                                                                                          child: Container(
                                                                                                            decoration: BoxDecoration(
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
                                                                                                            child: Padding(
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
                                                                            icon:
                                                                                Icon(
                                                                              Icons.edit,
                                                                              size: 13,
                                                                            )),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Text("Time:"),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(item
                                                                        .time
                                                                        .toString()),
                                                                    item.full.toString() ==
                                                                            '1'
                                                                        ? Text(
                                                                            '')
                                                                        : IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return Scaffold(
                                                                                      body: Center(
                                                                                        child: Container(
                                                                                          height: MediaQuery.of(context).size.height * 0.4,
                                                                                          width: MediaQuery.of(context).size.height * 0.4,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors.black.withOpacity(0.7),
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: Form(
                                                                                            key: key,
                                                                                            child: Center(
                                                                                              child: Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 25.0),
                                                                                                    child: Align(
                                                                                                      alignment: Alignment.topLeft,
                                                                                                      child: Text(
                                                                                                        'Update Time',
                                                                                                        style: TextStyle(color: Colors.yellow),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 50,
                                                                                                  ),
                                                                                                  Padding(
                                                                                                      padding: EdgeInsets.symmetric(horizontal: 25),
                                                                                                      child: Container(
                                                                                                        height: 30,
                                                                                                        decoration: BoxDecoration(
                                                                                                          border: Border.all(color: Colors.white, width: 0.5),
                                                                                                          boxShadow: [
                                                                                                            BoxShadow(
                                                                                                              color: Colors.black.withOpacity(0.5),
                                                                                                              spreadRadius: 2,
                                                                                                              blurRadius: 5,
                                                                                                              offset: Offset(0, 2),
                                                                                                            ),
                                                                                                          ],
                                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                                          color: Colors.white.withOpacity(0.3),
                                                                                                        ),
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.symmetric(
                                                                                                            horizontal: 8.0,
                                                                                                          ),
                                                                                                          child: TextFormField(
                                                                                                            validator: (value) {
                                                                                                              if (value!.isEmpty) {
                                                                                                                return 'Required!';
                                                                                                              } else {
                                                                                                                return null;
                                                                                                              }
                                                                                                            },
                                                                                                            controller: name, // Make sure _dateController is initialized
                                                                                                            style: TextStyle(color: Colors.grey),
                                                                                                            decoration: InputDecoration(
                                                                                                              hintText: 'Time',
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
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        InkWell(
                                                                                                          onTap: () {
                                                                                                            if (key.currentState!.validate()) {
                                                                                                              editTime(context, name.text, item.id.toString());
                                                                                                              Navigator.pop(context);
                                                                                                            }
                                                                                                          },
                                                                                                          splashColor: Colors.black,
                                                                                                          child: Container(
                                                                                                            decoration: BoxDecoration(
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
                                                                                                            child: Padding(
                                                                                                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                                                                                                              child: Text(
                                                                                                                "Ok",
                                                                                                                style: TextStyle(color: Colors.white),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        InkWell(
                                                                                                          onTap: () {
                                                                                                            Navigator.pop(context);
                                                                                                          },
                                                                                                          splashColor: Colors.black,
                                                                                                          child: Container(
                                                                                                            decoration: BoxDecoration(
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
                                                                                                            child: Padding(
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
                                                                            icon:
                                                                                Icon(
                                                                              Icons.edit,
                                                                              size: 13,
                                                                            )),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Text("Capacity:"),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(item
                                                                        .capacity
                                                                        .toString()),
                                                                    item.full.toString() ==
                                                                            '1'
                                                                        ? Text(
                                                                            '')
                                                                        : IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return Scaffold(
                                                                                      body: Center(
                                                                                        child: Container(
                                                                                          height: MediaQuery.of(context).size.height * 0.4,
                                                                                          width: MediaQuery.of(context).size.height * 0.4,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors.black.withOpacity(0.7),
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: Form(
                                                                                            key: key,
                                                                                            child: Center(
                                                                                              child: Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 25.0),
                                                                                                    child: Align(
                                                                                                      alignment: Alignment.topLeft,
                                                                                                      child: Text(
                                                                                                        'Update capacity',
                                                                                                        style: TextStyle(color: Colors.yellow),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 50,
                                                                                                  ),
                                                                                                  Padding(
                                                                                                      padding: EdgeInsets.symmetric(horizontal: 25),
                                                                                                      child: Container(
                                                                                                        height: 30,
                                                                                                        decoration: BoxDecoration(
                                                                                                          border: Border.all(color: Colors.white, width: 0.5),
                                                                                                          boxShadow: [
                                                                                                            BoxShadow(
                                                                                                              color: Colors.black.withOpacity(0.5),
                                                                                                              spreadRadius: 2,
                                                                                                              blurRadius: 5,
                                                                                                              offset: Offset(0, 2),
                                                                                                            ),
                                                                                                          ],
                                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                                          color: Colors.white.withOpacity(0.3),
                                                                                                        ),
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.symmetric(
                                                                                                            horizontal: 8.0,
                                                                                                          ),
                                                                                                          child: TextFormField(
                                                                                                            validator: (value) {
                                                                                                              if (value!.isEmpty) {
                                                                                                                return 'Required!';
                                                                                                              } else {
                                                                                                                return null;
                                                                                                              }
                                                                                                            },
                                                                                                            controller: name, // Make sure _dateController is initialized
                                                                                                            style: TextStyle(color: Colors.grey),
                                                                                                            decoration: InputDecoration(
                                                                                                              hintText: 'Capacity',
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
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        InkWell(
                                                                                                          onTap: () {
                                                                                                            if (key.currentState!.validate()) {
                                                                                                              editCapacity(context, name.text, item.id.toString());
                                                                                                              Navigator.pop(context);
                                                                                                            }
                                                                                                          },
                                                                                                          splashColor: Colors.black,
                                                                                                          child: Container(
                                                                                                            decoration: BoxDecoration(
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
                                                                                                            child: Padding(
                                                                                                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                                                                                                              child: Text(
                                                                                                                "Ok",
                                                                                                                style: TextStyle(color: Colors.white),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        InkWell(
                                                                                                          onTap: () {
                                                                                                            Navigator.pop(context);
                                                                                                          },
                                                                                                          splashColor: Colors.black,
                                                                                                          child: Container(
                                                                                                            decoration: BoxDecoration(
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
                                                                                                            child: Padding(
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
                                                                            icon:
                                                                                Icon(
                                                                              Icons.edit,
                                                                              size: 13,
                                                                            )),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Text("Booked:"),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(item
                                                                        .booked
                                                                        .toString()),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Text("Vacant:"),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(item
                                                                        .vacant
                                                                        .toString()),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Text("Status:"),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(item.full.toString() ==
                                                                            '0'
                                                                        ? 'Available'
                                                                        : 'Full'),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Text("Email:"),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(item
                                                                        .email
                                                                        .toString()),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20),
                                                      ]),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
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
                                              CupertinoIcons.bus,
                                              color: Colors.purple,
                                            ),
                                            radius: 18,
                                            backgroundColor:
                                                Colors.purple.withOpacity(0.3),
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
                                                  CupertinoIcons.location_solid,
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
                                                  item.fare.toString() +
                                                      '(MWK)',
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
                                            item.full.toString() == '0'
                                                ? Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
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
                                                              SizedBox(
                                                                  width: 2),
                                                              Text(
                                                                'Available',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .green
                                                                      .shade400,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.yellow
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 10.0,
                                                        left: 5,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 3,
                                                            backgroundColor:
                                                                Colors.yellow
                                                                    .shade700,
                                                          ),
                                                          SizedBox(width: 2),
                                                          Text(
                                                            'Full',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .yellow
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

                                    // Booking button
                                  ],
                                ),
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
          )
        ],
      ),
    );
  }
}

class Tickets {
  String? id;
  String? route;
  String? fare;
  String? time;
  String? company;
  String? email;
  String? capacity;
  String? booked;
  String? vacant;
  String? company_id;
  String? full;

  Tickets({
    required this.id,
    required this.route,
    required this.fare,
    required this.time,
    required this.company,
    required this.email,
    required this.capacity,
    required this.booked,
    required this.vacant,
    required this.company_id,
    required this.full,
  });

  Tickets.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        route = json['route'].toString(),
        fare = json['fare'].toString(),
        time = json['time'].toString(),
        company = json['company'].toString(),
        email = json['email'].toString(),
        capacity = json['capacity'].toString(),
        booked = json['booked'].toString(),
        vacant = json['vacant'].toString(),
        company_id = json['company_id'].toString(),
        full = json['full'].toString();
}
