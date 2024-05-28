import 'dart:core';

import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  //user details fetch
  String? _userId;
  String? _userFullname;
  String? _userEmail;
  String? _userPhone;
  String? _userCity;
  String? _userRole;

  //user ticket fetch
  String? _ticketId;
  String? _routes;
  String? _fare;
  String? _seatNum;
  String? _company;
  String? _busId;
  String? _date;
  String? _time;
  String? _transId;
  String? _status;
  String? _bookedOn;

  //chech logged status
  bool _loggedIn = false;
  get loggedIn => _loggedIn;
  void setLoggedStatus(bool state) {
    _loggedIn = state;
    notifyListeners();
  }

  //users details getters

  String? get userId => _userId;
  String? get userFullname => _userFullname;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;
  String? get userCity => _userCity;
  String? get userRole => _userRole;

  //users ticket getters

  String? get ticketId => _ticketId;
  String? get routes => _routes;
  String? get fare => _fare;
  String? get seatNum => _seatNum;
  String? get company => _company;
  String? get busId => _busId;
  String? get date => _date;
  String? get time => _time;
  String? get transId => _transId;
  String? get status => _status;
  String? get bookedOn => _bookedOn;

  //set user details
  void setUserDetails(String userid, String fullname, String email,
      String phone, String city, String role) {
    _userId = userid;
    _userFullname = fullname;
    _userEmail = email;
    _userPhone = phone;
    _userCity = city;
    _userRole = role;
    notifyListeners();
  }

  //set ticket details
  setTicketDetails(String ticketId, routes, fare, seatNum, company, busId, date,
      time, transId, status, bookedOn) {
    _ticketId = ticketId;
    _routes = routes;
    _fare = fare;
    _seatNum = seatNum;
    _company = company;
    _busId = busId;
    _date = date;
    _time = time;
    _transId = transId;
    _status = status;
    _bookedOn = bookedOn;
    notifyListeners();
  }

  // void setUserEmail(String email) {
  //   _userEmail = email;
  //   notifyListeners();
  // }

  void clearUserDetails() {
    _userId = null;
    _userFullname = null;
    _userEmail = null;
    _userPhone = null;
    _userCity = null;
    _userRole = null;
    notifyListeners();
  }

  // claer ticket details
  void clearTicketDetails() {
    _ticketId = null;
    _routes = null;
    _fare = null;
    _seatNum = null;
    _company = null;
    _busId = null;
    _date = null;
    _time = null;
    _transId = null;
    _status = null;
    _bookedOn = null;
    notifyListeners();
  }
}
