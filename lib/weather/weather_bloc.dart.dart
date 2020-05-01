import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:weather_app/weather/weather_state.dart.dart';
import 'weather_actions.dart.dart';
import '../data/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc(this.repository);

  @override
  WeatherState get initialState => WeatherInitial();

  @override
  Stream<WeatherState> mapEventToState(
      WeatherEvent event,
      ) async* {
    // Emitting a state from the asynchronous generator
    yield WeatherLoading();
    // Branching the executed logic by checking the event type
    if (event is GetWeather) {
      // Emit either Loaded or Error
      try {
        final weather = await repository.fetchWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError("Couldn't fetch weather. Is the device online?");
      }
    } else if (event is GetDetailedWeather) {

      try {
        final weather = await repository.fetchDetailedWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError("Couldn't fetch weather. Is the device online?");
      }
    }
  }
}