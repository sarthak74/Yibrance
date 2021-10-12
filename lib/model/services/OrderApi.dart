import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/OrderListItem.dart';

class OrderApi {
  LocalStorage storage = LocalStorage('silkroute');

  Future<List<OrderListItem>> getmyorders() async {
    try {
      var reqBody = {
        //userID
      };
      var uri = Math().ip();
      var url = Uri.parse(uri + '/x/y/z');
      final res = await http.post(url, body: reqBody);
      var decodedRes2 = jsonDecode(res.body);
      List<OrderListItem> resp = [];
      for (var i in decodedRes2) {
        OrderListItem r = OrderListItem.fromMap(i);
        resp.add(r);
      }
      return resp;
    } catch (e) {
      print("error - $e");
      return e;
    }
  }
}