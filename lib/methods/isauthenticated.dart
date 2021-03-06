import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:localstorage/localstorage.dart';

class Methods {
  LocalStorage storage = LocalStorage('silkroute');

  Future<bool> isAuthenticated() async {
    var contact = await storage.getItem('contact');

    if (contact != null) {
      if (contact.length != 10) {
        contact = null;
        storage.clear();
      }
    }
    print("isAuth -- $contact");
    return (contact != null && contact.length == 10);
  }

  dynamic getUser() async {
    dynamic user = await storage.getItem('user');
    return user;
  }

  dynamic getUserData(String key) async {
    dynamic user = await storage.getItem('user');
    return user[key];
  }

  void logout(context) async {
    await storage.clear();
    print(
        "Logout \n Contact - ${storage.getItem('contact') == null ? "null" : "In"}");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Loader()),
        (Route<dynamic> route) => false);
    Navigator.of(context).pushNamed('/enter_contact');
  }
}
