import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeather extends WeatherEvent {
  final String cityName;
  const GetWeather(this.cityName);

  @override
  List<Object> get props => [cityName];
}
class GetInitial extends WeatherEvent {
  const GetInitial();

  @override
  List<Object> get props => [];
}

class GetDetailedWeather extends WeatherEvent {
  final String cityName;
  const GetDetailedWeather(this.cityName);

  @override
  List<Object> get props => [cityName];
}
