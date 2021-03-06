import 'dart:convert';

import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';

class AWS {
  LocalStorage storage = LocalStorage('silkroute');
  Future<Map<String, dynamic>> getUrl(Map<String, dynamic> file) async {
    try {
      var uri1 = Math().ip();
      var url1 = Uri.parse(uri1 + '/getAWSSignedUrl');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res1 = await http.post(
        url1,
        headers: headers,
        body: json.encode(file),
      );
      var decodedRes2 = jsonDecode(res1.body);
      print("get upload url res -  $decodedRes2");
      return decodedRes2;
    } catch (err) {
      print("get upload url error - $err");
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> uploadToS3(String url, File image) async {
    try {
      var uri = await Uri.parse(url);
      var res = await http.put(uri, body: image.readAsBytesSync());
      print("Image upload statusCode: ${res.statusCode}");
      return {"success": true};
    } catch (err) {
      print("uploading to s3 error - $err");
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> uploadImage(File image, String name) async {
    try {
      var params = {"filename": name, "path": image.path};
      print(params);
      // var res = {"success": true, "uploadUrl": "test", "downloadUrl": "test"};
      var res = await getUrl(params);
      if (res['success'] == true) {
        // var uploadRes = {"success": true};
        var uploadRes = await uploadToS3(res['uploadUrl'], image);
        if (uploadRes['success'] == true) {
          return {
            "success": true,
            "msg": "Image uploaded successfully",
            "downloadUrl": res['downloadUrl']
          };
        } else {
          throw new Error();
        }
      } else {
        throw new Error();
      }
    } catch (err) {
      print("image upload to s3 error - $err");
      return {"success": false, "err": err};
    }
  }
}
