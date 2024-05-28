import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services.dart';

class CustomerCutsomers extends StatefulWidget {
  CustomerCutsomers({super.key});

  @override
  State<CustomerCutsomers> createState() => _CustomerCutsomerssState();
}

class _CustomerCutsomerssState extends State<CustomerCutsomers> {
  List<Map<String, dynamic>> _users = [];
  String selectedCompany = 'Customer';
  List<String> companiesz = [
    'Customer',
    'Company',
    'Company',
  ];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    uactive;
  }

  bool uactive = true;

  Future<void> _fetchUsers() async {
    final url = Uri.parse('$urla/users/getall.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _users = List<Map<String, dynamic>>.from(jsonData);
      });
    } else {
      throw Exception('Failed to load users');
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
                  CupertinoIcons.person_3_fill,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "Users List",
                style: TextStyle(color: Color(0XFFe8e8e8)),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = _users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 0.5, color: Colors.purple.shade400),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Colors.purple.withOpacity(0.25),
                                  child: CircleAvatar(
                                    child: Icon(
                                      CupertinoIcons.person_alt,
                                      color: Colors.purple,
                                    ),
                                    radius: 18,
                                    backgroundColor:
                                        Colors.purple.withOpacity(0.3),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.person_alt,
                                            color: Colors.grey,
                                            size: 13,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            user['fullname'],
                                            style: TextStyle(
                                                color: Colors.white60),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.envelope_fill,
                                            color: Colors.grey,
                                            size: 13,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            user['email'],
                                            style: TextStyle(
                                                color: Colors.white60),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.circle_filled,
                                            color: Colors.grey,
                                            size: 13,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            user['status'],
                                            style: TextStyle(
                                                color: Colors.white60),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.calendar_badge_plus,
                                            color: Colors.grey,
                                            size: 13,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            user['joined']
                                                .toString()
                                                .substring(0, 10),
                                            style: TextStyle(
                                                color: Colors.white60),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.briefcase_fill,
                                          color: Colors.grey,
                                          size: 13,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          user['role'].toString(),
                                          style:
                                              TextStyle(color: Colors.white60),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              width: 0.2, color: Colors.white),
                                          color: Colors.black45),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      actions: [
                                                        IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  'Send');
                                                            },
                                                            icon: Icon(
                                                              Icons.arrow_back,
                                                              color:
                                                                  Colors.grey,
                                                            ))
                                                      ],
                                                      backgroundColor: Colors
                                                          .black
                                                          .withOpacity(0.9),
                                                      content: Container(
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
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 20.0),
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  "Assign a role",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              Divider(),
                                                              SizedBox(
                                                                height: 60,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.white, width: 0.5),
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
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        color: Colors.white.withOpacity(0.3)),
                                                                    child: DropdownButtonFormField<String>(
                                                                      value:
                                                                          selectedCompany,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
                                                                        prefixIcon:
                                                                            Icon(
                                                                          CupertinoIcons
                                                                              .briefcase_fill,
                                                                          color:
                                                                              Colors.grey[400],
                                                                        ),
                                                                        labelText:
                                                                            "Roles",
                                                                        labelStyle:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              Colors.grey[400],
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (String?
                                                                              newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedCompany =
                                                                              newValue!;
                                                                        });
                                                                      },
                                                                      items: companiesz.map<
                                                                          DropdownMenuItem<
                                                                              String>>(
                                                                        (String
                                                                            value) {
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                value,
                                                                            child:
                                                                                Text(
                                                                              value,
                                                                              style: TextStyle(color: Colors.black87),
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
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            20.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    assignRole(
                                                                        context,
                                                                        user[
                                                                            'email'],
                                                                        selectedCompany);
                                                                    Navigator.pop(
                                                                        context,
                                                                        'Send');
                                                                  },
                                                                  splashColor:
                                                                      Colors
                                                                          .black,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            12.0),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
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
                                                                                88),
                                                                        child:
                                                                            Text(
                                                                          "Submit",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
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
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.edit,
                                                size: 15, color: Colors.green),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (uactive == true) {
                                                uactive = false;
                                                disableUser(
                                                    context, user['email']);

                                                setState(() {
                                                  _fetchUsers();
                                                });
                                              } else {
                                                uactive = true;
                                                enableUser(
                                                    context, user['email']);
                                                _fetchUsers();
                                              }
                                              setState(() {
                                                _fetchUsers();
                                              });
                                            },
                                            icon: Icon(
                                                uactive
                                                    ? Icons.person_off_rounded
                                                    : Icons.person,
                                                size: 15,
                                                color: Colors.yellow),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              deleteUser(context,
                                                  user['email'].toString());
                                            },
                                            icon: Icon(Icons.delete_forever,
                                                size: 15, color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }
}
