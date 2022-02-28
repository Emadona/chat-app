
import '../models/weather.dart';
import '../webservices/webservices.dart';

class WeatherRepository{
  WebServices _webServices;

  WeatherRepository(this._webServices);

  Future<Weather> getAllTemp(String city)async{
    final resualt = await _webServices.getTemp(city);
    return Weather.fromJson(resualt);
  }

  Future<Weather> getAllTempurature(String city)async{
    try{
    final result = await _webServices.getTemparutre(city);
    print('repository '+city.toString());
    return Weather.fromJson(result);
  }on Error{
      return Weather(state: 'mist',temp: 0.0,icon: '50n');
    }
  }
}