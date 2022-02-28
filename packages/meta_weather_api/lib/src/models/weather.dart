
class Weather{
  // int id;
  String state;
  double temp;
  String icon;

  Weather({
    // required this.id,
    required this.state,
    required this.temp,
    required this.icon
  });

  factory Weather.fromJson(Map<String,dynamic> json){
    Weather weather = Weather(
        // id: json['weather'][0]['id'],
        state: json['weather'][0]['description'],
        temp: json['main']['temp'],
        icon: json['weather'][0]['icon'],

    );
    return weather;
  }
}