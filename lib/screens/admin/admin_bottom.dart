import 'package:ebus/screens/admin/admin_home.dart';
import 'package:ebus/screens/admin/admin_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'admin_buses.dart';
import 'admin_tickets.dart';

class BottomNav extends StatefulWidget {
  late int index;

  BottomNav({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final _screens = [
    AdminHome(),
    AdminBus(),
    AdminTickets(),
    AdminUsers(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[widget.index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: widget.index,
        selectedItemColor: Colors.purpleAccent,
        onTap: (index) {
          setState(() {
            widget.index = index;
          });
        },
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            label: "Home",
            icon: Icon(
              CupertinoIcons.home,
              //color: Color(0XFFe8e8e8),
            ),
          ),
          BottomNavigationBarItem(
            label: "Buses",
            icon: Icon(
              CupertinoIcons.bus,
              semanticLabel: "Bus list",
              // color: Color(0XFFe8e8e8),
            ),
          ),
          BottomNavigationBarItem(
            label: "Tickets",
            icon: Icon(
              CupertinoIcons.tickets_fill,
              // color: Color(0XFFe8e8e8),
            ),
          ),
          BottomNavigationBarItem(
            label: "Users",
            icon: Icon(
              CupertinoIcons.person_3_fill,
              // color: Color(0XFFe8e8e8),
            ),
          ),
        ],
      ),
    );
  }
}
