import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:ebus/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services.dart';

class CustomerTickets extends StatefulWidget {
  const CustomerTickets({super.key});

  @override
  State<CustomerTickets> createState() => _CustomerTicketsState();
}

class _CustomerTicketsState extends State<CustomerTickets> {
  @override
  void initState() {
    super.initState();
    fetchBuses();
  }

  Future<List<Tickets>> fetchBuses() async {
    final response =
        await http.post(Uri.parse('$urla/buses/mytickets.php'), body: {
      'uid': Provider.of<UserProvider>(context, listen: false).userId,
    });

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Tickets.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tickets');
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
                  CupertinoIcons.tickets_fill,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "Tickets List",
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
                                                          GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Scaffold(
                                                                      body:
                                                                          Center(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.4,
                                                                          width:
                                                                              MediaQuery.of(context).size.height * 0.4,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.black.withOpacity(1),
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                BarcodeWidget(
                                                                                  key: UniqueKey(), // Add a key to force the rebuild
                                                                                  barcode: Barcode.qrCode(),
                                                                                  data: '${item.id.toString()}',
                                                                                  width: 150, // Adjust width as needed
                                                                                  height: 150,
                                                                                  color: Colors.yellow,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 30,
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  splashColor: Colors.black,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 70.0),
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
                                                                                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60),
                                                                                        child: Text(
                                                                                          "Close",
                                                                                          style: TextStyle(color: Colors.white),
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
                                                            child:
                                                                BarcodeWidget(
                                                              key:
                                                                  UniqueKey(), // Add a key to force the rebuild
                                                              barcode: Barcode
                                                                  .qrCode(),
                                                              data:
                                                                  '${item.id.toString()}',
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
                                                              Text("Company:"),
                                                              Text(item.company
                                                                  .toString()),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("Ticket#:"),
                                                              Text(item.id
                                                                  .toString())
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("Customer:"),
                                                              Text(
                                                                  '${Provider.of<UserProvider>(context, listen: false).userFullname}'),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("Email:"),
                                                              Text(
                                                                  '${Provider.of<UserProvider>(context, listen: false).userEmail}'),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("Route:"),
                                                              Text(
                                                                  '${item.route.toString()}'),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Departure:"),
                                                              Text(
                                                                  '${item.time.toString()}'),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("Date:"),
                                                              Text(
                                                                  '${item.date.toString()}'),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Fare (MWK):"),
                                                              Text(
                                                                  '${item.price.toString()}'),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Booked On:"),
                                                              Text(
                                                                  '${item.bookedOn.toString()}'),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("TransID:"),
                                                              Container(
                                                                width: 180,
                                                                child: Text(
                                                                  '${item.transId.toString()}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("Seat#:"),
                                                              Text(
                                                                  '${item.seatNum.toString()}'),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          item.status.toString() ==
                                                                  'Pending'
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        "Status:"),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .yellow,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8.0),
                                                                        child:
                                                                            Text(
                                                                          '${item.status.toString()}',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black.withOpacity(0.5),
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
                                                                    Text(
                                                                        "Status:"),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .green,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8.0),
                                                                        child:
                                                                            Text(
                                                                          '${item.status.toString()}',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black.withOpacity(0.5),
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
                                              CupertinoIcons.ticket_fill,
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
                                                  item.price.toString() +
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
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month,
                                                  size: 14,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  item.date.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white60),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 35,
                                            ),
                                            // Bus availability status
                                            item.status.toString() == 'Cleared'
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
                                                                'Cleared',
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
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(
                                                              CupertinoIcons
                                                                  .trash_fill))
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
                                                            'Pending',
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
  String? company;
  String? route;
  String? time;
  String? date;
  String? price;
  String? status;
  String? bookedOn;
  String? transId;
  String? seatNum;

  Tickets({
    required this.id,
    required this.company,
    required this.route,
    required this.time,
    required this.date,
    required this.price,
    required this.status,
    required this.bookedOn,
    required this.transId,
    required this.seatNum,
  });

  Tickets.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        company = json['company'].toString(),
        route = json['routes'].toString(),
        time = json['time'].toString(),
        date = json['date'].toString(),
        price = json['fare'].toString(),
        status = json['status'].toString(),
        bookedOn = json['created'].toString(),
        transId = json['transid'].toString(),
        seatNum = json['seat_num'].toString();
}
