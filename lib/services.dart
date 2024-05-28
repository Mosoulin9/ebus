import 'dart:convert';
import 'dart:async';
import 'package:ebus/provider.dart';
import 'package:ebus/screens/admin/admin_bottom.dart';
import 'package:ebus/screens/company/company_bottom.dart';
import 'package:ebus/screens/customer/customer_bottom.dart';
import 'package:ebus/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

String? customers;
String? companycustomers;
String? companies;
String? buscompanies;
String? tickets;
String? companytickets;
String? revenue;
String? companyrevenue;

String urla = 'https://aaahaiidstd.000webhostapp.com/ebus';

bool changer = false;

//check logged in status
void checkStatus(BuildContext context) {
  if (Provider.of<UserProvider>(context, listen: changer).loggedIn == true) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomNav(index: 0)),
    );
  }
}

//signup
Future signup(BuildContext context, name, email, password) async {
  var res = await http.post(Uri.parse('$urla/signup/index.php'), body: {
    'name': name.toString(),
    'email': email.toString(),
    'password': password.toString()
  });
  if (res.statusCode == 200) {
    if (res.body == 'Successfully registered') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else if (res.body == 'Email already registered!') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Registration failed.') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//company register
Future compsignup(BuildContext context, name, email, password) async {
  var res = await http.post(Uri.parse('$urla/signup/comp_reg.php'), body: {
    'name': name.toString(),
    'email': email.toString(),
    'password': password.toString()
  });
  if (res.statusCode == 200) {
    if (res.body == 'Successfully registered') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else if (res.body == 'Email or Company Id Already registered!') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Registration failed.') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//login
Future login(BuildContext context, email, password) async {
  var res = await http.post(Uri.parse('$urla/signin/index.php'),
      body: {'email': email.toString(), 'password': password.toString()});
  if (res.statusCode == 200) {
    if (res.body == 'Admin logged in') {
      changer = true;
      await getUserDetails(context, email.toString());
      await getCustomers();
      await getCompanies();
      await getTickets();
      await getRevenue();
      Provider.of<UserProvider>(context, listen: false).setLoggedStatus(true);
      print(Provider.of<UserProvider>(context, listen: false).loggedIn);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BottomNav(index: 0)));
    } else if (res.body == 'Company logged in') {
      await getUserDetails(context, email.toString());
      await getCompanyCustomers(email);
      await getBusCompanies(email);
      await getCompanyTickets(email);
      await getCompanyRevenue(email);
      Provider.of<UserProvider>(context, listen: false).setLoggedStatus(true);
      print(Provider.of<UserProvider>(context, listen: false).loggedIn);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CompanyBottomNav(index: 0)));
    } else if (res.body == 'Customer logged in') {
      await getUserDetails(context, email.toString());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CustomerBottomNav(index: 0)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//logout
Future logout(BuildContext context, email) async {
  var res = await http.post(Uri.parse('$urla/logout/index.php'),
      body: {'email': email.toString()});
  if (res.statusCode == 200) {
    if (res.body == 'logged out') {
      changer = false;
      Provider.of<UserProvider>(context, listen: false).setLoggedStatus(false);
      print(Provider.of<UserProvider>(context, listen: false).loggedIn);
      Provider.of<UserProvider>(context, listen: false).clearUserDetails();
      Provider.of<UserProvider>(context, listen: false).clearTicketDetails();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } else if (res.body == 'failed to logout') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//get user details
Future<void> getUserDetails(BuildContext context, String email) async {
  var url = Uri.parse('$urla/users/userds.php');
  var body = {'email': email};

  var response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    bool success = data['success'];

    if (success) {
      Map<String, dynamic> userDetails = data['user'];
      print(userDetails['id'].toString());
      Provider.of<UserProvider>(context, listen: false).setUserDetails(
          userDetails['id'].toString(),
          userDetails['fullname'],
          userDetails['email'],
          userDetails['phone'],
          userDetails['city'],
          userDetails['role']);
    } else {
      // Show error message if login is unsuccessful
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(5),
            color: Colors.red.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    'Login unsuccessful',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
  } else {
    // Handle other HTTP status codes
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to fetch user details'),
    ));
  }
}

//forgotpass
Future forgotpass(BuildContext context, email) async {
  var res = await http.post(Uri.parse('$urla/signup/forgotpass.php'), body: {
    'email': email.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'New Password is sent to your email!') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else if (res.body == 'Email not found!') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//add company
Future addCompany(BuildContext context, name, license) async {
  var res = await http.post(Uri.parse('$urla/addcompany/index.php'), body: {
    'name': name.toString(),
    'license': license.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'Bus company added') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Already registered') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Registration failed.') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//add a bus by company
Future addABusCompany(BuildContext context, String route, String fare,
    String time, String capacity) async {
  var res = await http.post(Uri.parse('$urla/addcompany/add.php'), body: {
    'route': route,
    'fare': fare,
    'time': time,
    'capacity': capacity,
    'email': Provider.of<UserProvider>(context, listen: false).userEmail,
  });
  if (res.statusCode == 200) {
    if (res.body == 'Bus added') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Already added') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Adding failed.') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//send notification
Future sendNotification(BuildContext context, message) async {
  var res =
      await http.post(Uri.parse('$urla/sendnotification/index.php'), body: {
    'message': message.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'Notification Sent.') {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'failed to send notification') {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    print(res.body);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//send message
Future sendMessage(BuildContext context, message, sfullname, rid) async {
  var res =
      await http.post(Uri.parse('$urla/sendnotification/message.php'), body: {
    'message': message.toString(),
    'sid': sfullname.toString(),
    'rid': rid,
  });
  if (res.statusCode == 200) {
    if (res.body == 'Message Sent.') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'failed to send Message') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//send message
Future checkBus(BuildContext context, company, route, date, time) async {
  var res = await http.post(Uri.parse('$urla/users/chebus.php'), body: {
    'company': company,
    'route': route,
    'date': date,
    'time': time,
  });
  if (res.statusCode == 200) {
    if (res.body == true) {
    } else if (res.body == 'Bus is full!') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Select a valid date') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Bus not found!') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//send message
Future sendMessageAdmin(BuildContext context, message) async {
  var res =
      await http.post(Uri.parse('$urla/sendnotification/message2.php'), body: {
    'message': message.toString(),
    'sid': Provider.of<UserProvider>(context, listen: false).userEmail,
  });
  if (res.statusCode == 200) {
    if (res.body == 'Message Sent.') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'failed to send Message') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//get customers
Future getCustomers() async {
  var res = await http
      .post(Uri.parse('$urla/signin/fetchus.php'), body: {'get': 'get'});
  if (res.statusCode == 200) {
    customers = res.body.toString();
  }
}

//get customers
Future getCompanyCustomers(email) async {
  var res = await http
      .post(Uri.parse('$urla/signin/fetchus.php'), body: {'getcomp': email});
  if (res.statusCode == 200) {
    companycustomers = res.body.toString();
  }
}

//get companies
Future getCompanies() async {
  var res = await http
      .post(Uri.parse('$urla/signin/fetchbus.php'), body: {'get': 'get'});
  if (res.statusCode == 200) {
    companies = res.body.toString();
  }
}

//get bus companies
Future getBusCompanies(email) async {
  var res = await http
      .post(Uri.parse('$urla/signin/fetchbus.php'), body: {'getcomp': email});
  if (res.statusCode == 200) {
    buscompanies = res.body.toString();
  }
}

//get tickets
Future getTickets() async {
  var res = await http
      .post(Uri.parse('$urla/signin/fetchtickets.php'), body: {'get': 'get'});
  if (res.statusCode == 200) {
    tickets = res.body.toString();
  }
}

//get company tickets
Future getCompanyTickets(email) async {
  var res = await http.post(Uri.parse('$urla/signin/fetchtickets.php'),
      body: {'getcomp': email});
  if (res.statusCode == 200) {
    tickets = res.body.toString();
  }
}

//get revenue
Future getRevenue() async {
  var res = await http.get(Uri.parse('$urla/getrevenue/index.php'));
  if (res.statusCode == 200) {
    revenue = res.body.toString();
    print(res.body.toString());
  }
}

//get company revenue
Future getCompanyRevenue(email) async {
  var res = await http
      .post(Uri.parse('$urla/getrevenue/index.php'), body: {'getcomp': email});
  if (res.statusCode == 200) {
    companyrevenue = res.body.toString();
    print(res.body.toString());
  }
}

//update msg status
Future updateMsg(name) async {
  var res =
      await http.post(Uri.parse('$urla/sendnotification/updatemsg.php'), body: {
    'fullname': name.toString(),
  });
  if (res.statusCode == 200) {
    print(res.body);
  } else {
    print(res.body);
  }
}

//update notif status
Future updateNotif(name) async {
  var res = await http
      .post(Uri.parse('$urla/sendnotification/updatenotif.php'), body: {
    'fullname': name.toString(),
  });
  if (res.statusCode == 200) {
    print(res.body);
  } else {
    print(res.body);
  }
}

//deactivate user
Future disableUser(BuildContext context, email) async {
  var res = await http.post(Uri.parse('$urla/users/udateuser.php'),
      body: {'email': email.toString(), 'disable': 'disable'});
  if (res.statusCode == 200) {
    if (res.body == 'User deactivated') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Failed to deactivate') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//activate user
Future enableUser(BuildContext context, email) async {
  var res = await http.post(Uri.parse('$urla/users/udateuser.php'),
      body: {'email': email.toString(), 'enable': 'enable'});
  if (res.statusCode == 200) {
    if (res.body == 'User activated') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Failed to activate') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//delete user
Future deleteUser(BuildContext context, email) async {
  var res = await http.post(Uri.parse('$urla/users/udateuser.php'),
      body: {'email': email, 'delete': 'delete'});
  if (res.statusCode == 200) {
    if (res.body == 'User deleted') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Failed to delete') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

//assign role
Future assignRole(BuildContext context, email, role) async {
  var res = await http.post(Uri.parse('$urla/users/udateuser.php'),
      body: {'email': email, 'assign': role.toString()});
  if (res.statusCode == 200) {
    if (res.body == 'Role assigned') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else if (res.body == 'Failed to assign role') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

// update name
Future updateName(
  BuildContext context,
  name,
) async {
  var res = await http.post(Uri.parse('$urla/users/uname.php'), body: {
    'uid': Provider.of<UserProvider>(context, listen: false).userId,
    'name': name.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'Name updated!') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      await getUserDetails(context,
          Provider.of<UserProvider>(context, listen: false).userEmail!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

// update phone
Future updatePhone(
  BuildContext context,
  name,
) async {
  var res = await http.post(Uri.parse('$urla/users/uname.php'), body: {
    'uid': Provider.of<UserProvider>(context, listen: false).userId,
    'phone': name.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'Phone updated!') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radiu
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      await getUserDetails(context,
          Provider.of<UserProvider>(context, listen: false).userEmail!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

// update city
Future updateCity(
  BuildContext context,
  name,
) async {
  var res = await http.post(Uri.parse('$urla/users/uname.php'), body: {
    'uid': Provider.of<UserProvider>(context, listen: false).userId,
    'city': name.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'City updated!') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radiu
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
      await getUserDetails(context,
          Provider.of<UserProvider>(context, listen: false).userEmail!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

// check pass
Future checkPass(
  BuildContext context,
  name,
) async {
  var res = await http.post(Uri.parse('$urla/users/checkpass.php'), body: {
    'email': Provider.of<UserProvider>(context, listen: false).userEmail,
    'password': name.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'Found!') {
      TextEditingController name = TextEditingController();
      GlobalKey<FormState> key = GlobalKey<FormState>();
      TextEditingController name2 = TextEditingController();
      GlobalKey<FormState> key2 = GlobalKey<FormState>();
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
                                'Change Password',
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
                                  border: Border.all(
                                      color: Colors.white, width: 0.5),
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
                                      } else if (name.text != name2.text) {
                                        return 'Passwords mismatch!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller:
                                        name, // Make sure _dateController is initialized
                                    style: TextStyle(color: Colors.grey),
                                    decoration: InputDecoration(
                                      hintText: 'New Password',
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 0.5),
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
                                      } else if (name.text != name2.text) {
                                        return 'Passwords mismatch!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller:
                                        name2, // Make sure _dateController is initialized
                                    style: TextStyle(color: Colors.grey),
                                    decoration: InputDecoration(
                                      hintText: 'Confirm Password',
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (key.currentState!.validate()) {
                                      changePass(context, name2.text);
                                      Navigator.pop(context);
                                    }
                                  },
                                  splashColor: Colors.black,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.yellowAccent,
                                          width: 0.5),
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
                                          vertical: 8.0, horizontal: 40),
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
                                      border: Border.all(
                                          color: Colors.yellowAccent,
                                          width: 0.5),
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
                                          vertical: 8.0, horizontal: 40),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

// update pass
Future changePass(
  BuildContext context,
  name,
) async {
  var res = await http.post(Uri.parse('$urla/users/changepass.php'), body: {
    'email': Provider.of<UserProvider>(context, listen: false).userEmail,
    'password': name.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'Password changed!') {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radiu
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

// update route
Future editRoute(BuildContext context, name, id) async {
  var res = await http.post(Uri.parse('$urla/buses/editbus.php'), body: {
    'id': id,
    'route': name.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'Route changed!') {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radiu
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

// update fare
Future editFare(BuildContext context, name, id) async {
  var res = await http.post(Uri.parse('$urla/buses/editbus.php'), body: {
    'id': id,
    'fare': name.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'Fare changed!') {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radiu
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

// update time
Future editTime(BuildContext context, name, id) async {
  var res = await http.post(Uri.parse('$urla/buses/editbus.php'), body: {
    'id': id,
    'time': name.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'Time changed!') {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radiu
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}

// update capacity
Future editCapacity(BuildContext context, name, id) async {
  var res = await http.post(Uri.parse('$urla/buses/editbus.php'), body: {
    'id': id,
    'capacity': name.toString(),
  });
  if (res.statusCode == 200) {
    if (res.body == 'Capacity changed!') {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radiu
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.green.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 15,
                    color: Colors.green,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              )),
            ),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Faint shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 2), // Offset from the container
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.red.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 15,
                    color: Colors.red,
                  ),
                  Text(
                    res.body,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
            ),
          )));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Faint shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset from the container
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.red.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.red,
                ),
                Text(
                  res.body,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
        )));
  }
}
