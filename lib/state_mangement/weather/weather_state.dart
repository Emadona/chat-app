import 'package:meta_weather_api/meta_weather_api.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();

  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();

  @override
  List<Object> get props => [];
}

class WeatherError extends WeatherState {
  const WeatherError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}

class WeatherLoaded extends WeatherState {
  final String cityName;
  final Weather weather;

  const WeatherLoaded(this.cityName,this.weather);

  @override
  List<Object> get props => [cityName,weather];
}
