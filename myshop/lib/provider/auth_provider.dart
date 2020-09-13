import 'package:flutter/widgets.dart';
/// gives us to run code asyncronous
import 'dart:async';
import 'package:http/http.dart' as http;
// library to convert dart to JSON
import 'dart:convert';
// library to use sharedpreferences
import 'package:shared_preferences/shared_preferences.dart';

import '../model/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token; // always expire more than one hour
  String _userID;
  DateTime _expiryDate;
  Timer _authTimer;

  // check if user already logged in
  bool get isAuth {
    /// if we have a token and it didnt expire, then user is authenticated
    return token != null;
  }

  // get token user
  String get token {
    if (_expiryDate != null 
          && _expiryDate.isAfter(DateTime.now())
            && _token != null) {
      return _token;
    }
    return null;
  }

  // get id user
  String get userId {
    return _userID;
  }
  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBu39q0Nqo848DY2xJUh4wnG0I0dBNxiiA';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true // should be true based on documentation
        })
      );
      final responseData = json.decode(response.body);
      print(responseData); // print for see response body 
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // get token from authenticating
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDate = DateTime.now()
                      .add(
                        Duration(
                          seconds: int.parse(
                            responseData['expiresIn']
                          )
                        )
                      );
      _autoLogout();
      // update the auth provider
      notifyListeners();
      final userData = json.encode({
        'token': _token,
        'userId': _userID,
        'expiryDate': _expiryDate.toIso8601String()
      });
      /// store token to device with shared preferences
      //// 1. accessing sharedpreferences
      final sharedPreference = await SharedPreferences.getInstance(); // a future func that automically return a shared preferences instance
      /// 2. write data
      sharedPreference.setString(
        'userData', 
        userData
      );
    }
      catch(error) {
        throw error;
      }
  }

  // user sign up
  Future<void> signUp(String email, String password) async{
    return _authenticate(email, password, 'signUp');
  }

  // user sign in
  Future<void> signIn(String email, String password) async{
    return _authenticate(email, password,'signInWithPassword');
  }
  // auto login
  Future<bool> autoSignIn() async {
    /// accessing sharedPreferences
    final preferences = await SharedPreferences.getInstance();
    /// extract userData
    if (!preferences.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(
      preferences.getString('userData')
    ) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())) {
      return false; // token is invalid
    }
    _token = extractedUserData['token'];
    _userID = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  // user sign out
  Future<void> signOut() async {
    _token = null;
    _userID = null;
    _expiryDate = null;
    if( _authTimer != null ) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    // clear sharedpreferences data
    final sharedPreference = await SharedPreferences.getInstance();
    // sharedPreference.remove('userData');
    sharedPreference.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    // set a timer when token is expires
    final timeToExpired = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: timeToExpired), 
      signOut
    );
  }
}