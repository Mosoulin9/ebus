import 'dart:convert';
import 'package:ebus/provider.dart';
import 'package:ebus/screens/customer/customer_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services.dart';
import 'company_bottom.dart';

class CompanyMsg extends StatefulWidget {
  const CompanyMsg({super.key});

  @override
  State<CompanyMsg> createState() => _CompanyMsgState();
}

class _CompanyMsgState extends State<CompanyMsg> {
  @override
  void initState() {
    super.initState();
    fetchBuses();
  }

  Future<List<Tickets>> fetchBuses() async {
    final response =
        await http.post(Uri.parse('$urla/buses/mymsgs.php'), body: {
      'uid': Provider.of<UserProvider>(context, listen: false).userFullname,
    });

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Tickets.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load msgs');
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
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CompanyBottomNav(index: 0)));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
              title: Text(
                "Messages",
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
                                              color:
                                                  Colors.black.withOpacity(0.6),
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
                                                          Icons.message,
                                                          color: Colors.yellow,
                                                        ),
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
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(item.message
                                                                .toString()),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
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
                                              CupertinoIcons.envelope_fill,
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
                                                  CupertinoIcons
                                                      .number_square_fill,
                                                  size: 14,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  item.id.toString(),
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
                                                      .calendar_badge_plus,
                                                  size: 14,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  item.created.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white60),
                                                ),
                                              ],
                                            ),
                                            // Bus time
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.messenger,
                                                  size: 14,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  item.message.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white60),
                                                ),
                                              ],
                                            ),
                                            // Bus price
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
