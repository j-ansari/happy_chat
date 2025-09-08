import 'package:flutter/material.dart';
import 'package:happy_chat_app/src/core/helper/prefs.dart';
import '../../view/pages/contacts_page.dart';
import '../../view/pages/login_page.dart';

class Starter {
  static Future<Widget> decideStartWidget() async {
    final token = Preferences.getString(PrefsKey.token);
    if (token == null) return LoginPage();
    return ContactsPage();
  }
}
