import 'dart:async';
import 'package:sam_rider_app/src/config/configs.dart';
import 'package:sam_rider_app/src/model/place_item_res.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sam_rider_app/src/model/step_res.dart';

class PlaceService {
  static Future<List<PlaceItemRes>> searchPlace(String keyWord) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyB94toBjU5Ne7fz3xfjjS1PsgwaCabFKXg&language=pt&query=" +
            Uri.encodeQueryComponent(keyWord);

    print("search >>: " + url);
    var res = await http.get(url);
    if (res.statusCode == 200) {
      print(res.body);
      return PlaceItemRes.fromJson(json.decode(res.body));
    } else {
      return List();
    }
  }

  static Future<dynamic> getStep(
      double lat, double lng, double tolat, double tolng) async {
    String str_origin = "origin=" + lat.toString() + "," + lng.toString();
    // destination of route
    String str_dest =
        "destination=" + tolat.toString() + "," + tolng.toString();
    //sensor enabled
    String sensor = "sensor=false";
    String mode = "mode=driving";
    //building the parameters to the web service
    String parameters = str_origin + "&" + str_dest + "&" + sensor + "&" + mode;
    //output format
    String output = "json";
    //building the url to the webservice
    String url = "https://maps.googleapis.com/maps/api/directions/" +
        output +
        "?origin=" +
        parameters +
        "&key=AIzaSyB94toBjU5Ne7fz3xfjjS1PsgwaCabFKXg";
    final JsonDecoder _decoder = JsonDecoder();
    return http.get(url).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw Exception(res);
      }

      List<StepRes> steps;
      try {
        steps =
            _parseSteps(_decoder.convert(res)["routes"][0]["legs"][0]["steps"]);
      } catch (e) {
        throw new Exception(res);
      }
    });
  }

  static List<StepRes> _parseSteps(final responseBody) {
    var list =
        responseBody.map<StepRes>((json) => StepRes.fromJson(json)).toList();

    return list;
  }
}
