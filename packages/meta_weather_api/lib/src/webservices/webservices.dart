import 'dart:convert';

import 'package:http/http.dart' as http;
class WebServices{

  Future<dynamic> getnoOfCity(String city) async{
    final respone = await http.get(Uri.parse(
        'https://www.metaweather.com/api/location/search/?query=' + city));
    return jsonDecode(respone.body)[0]['woeid'];
  }

  Future<dynamic> getTemp(String city) async{
    final int woeid = await getnoOfCity(city);
    final result = await http.get(
        Uri.parse('https://www.metaweather.com/api/location/' + woeid.toString())
    );
    return jsonDecode(result.body)['consolidated_weather'][0];
  }
  
  Future<dynamic> getTemparutre(String city) async{
    final result = await http.get(
      Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=558d0cd9b7052875441081d53a45a4ae")
    );
    return jsonDecode(result.body);
  }


}