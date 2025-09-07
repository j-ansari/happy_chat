import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../view/pages/contacts_page.dart';
import '../../view/pages/login_page.dart';

class Starter {
  static Future<Widget> decideStartWidget() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return LoginPage();
    return ContactsPage();
  }
}
