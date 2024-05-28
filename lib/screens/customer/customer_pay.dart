import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerPay extends StatefulWidget {
  String? id;
  String? company;
  String? route;
  String? time;
  String? price;
  String? date;
  CustomerPay({
    super.key,
    required this.id,
    required this.company,
    required this.route,
    required this.time,
    required this.price,
    required this.date,
  });
  @override
  State<CustomerPay> createState() => _CustomerPayState();
}

class _CustomerPayState extends State<CustomerPay> {
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
                "Payment",
                style: TextStyle(color: Color(0XFFe8e8e8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Center(child: Text('Proceed')),
            ),
          )
        ],
      ),
    );
  }
}
