import 'package:ebus/screens/admin/admin_home.dart';
import 'package:ebus/screens/admin/admin_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'company_buses.dart';
import 'company_customers.dart';
import 'company_home.dart';
import 'company_tickets.dart';

class CompanyBottomNav extends StatefulWidget {
  late int index;

  CompanyBottomNav({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<CompanyBottomNav> createState() => _CompanyBottomNavState();
}

class _CompanyBottomNavState extends State<CompanyBottomNav> {
  final _screens = [
    CompanyHome(),
    CompanyBus(),
    CompanyTickets(),
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
        ],
      ),
    );
  }
}
