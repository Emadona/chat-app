// @dart=2.9
import 'package:chat/state_mangement/weather/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_weather_api/meta_weather_api.dart';

class WeatherStatus extends StatefulWidget {
  WeatherStatus(this.city);
  String city;

  @override
  _WeatherStatusState createState() => _WeatherStatusState();
}

// class _WeatherStatusState extends State<WeatherStatus> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Image.asset('assets/full-moon.png',fit: BoxFit.fill,)
//       ],
//     );
//   }
// }

class _WeatherStatusState extends State<WeatherStatus> {
  @override
  void initState() {
    _buildWeather();
    context.read<WeatherBloc>().add(GetWeather(widget.city));

    super.initState();
  }

  void _buildWeather() {
    // final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    // weatherBloc.add(GetWeather(widget.city));
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (_, state) {
      if (state is WeatherInitial) {
        print('initial');
        return _buildInitial();
      } else if (state is WeatherLoading) {
        print('loading');

        return _buildLoading();
      } else if (state is WeatherLoaded) {
        print('loaded');

        print(state.weather.icon);
        return _buildLoaded(state.weather);
      }
      return _buildInitial();
    });
  }

  _buildInitial() => Row(
        children: [
          Text(
            '--',
            style: TextStyle(color: Colors.black87),
          ),
        ],
      );
  _buildLoading() => Row(
        children: [CircularProgressIndicator()],
      );
  _buildLoaded(Weather weather) => Row(
        children: [
          Text(weather.temp.toStringAsFixed(1),
              style: TextStyle(color: Colors.blue)),
          Image.asset('assets/weather/${weather.icon}.png')
        ],
      );

  _weatherIconsState() {}
}
