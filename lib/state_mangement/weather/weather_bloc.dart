import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta_weather_api/meta_weather_api.dart';


import './bloc.dart';
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc(this.weatherRepository) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(
      WeatherEvent event,
      ) async* {
    yield WeatherLoading();
    if (event is GetWeather) {
      final weather = await weatherRepository.getAllTempurature(event.cityName);
      yield WeatherLoaded(event.cityName,weather);
    }
    if(event is GetInitial){
      yield WeatherInitial();
    }


  }

  @override
  // TODO: implement initialState
  WeatherState get initialState => throw WeatherInitial();
}
