import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_forecast/features/weather_info/data/models/weather_info_model.dart';
import 'package:weather_forecast/features/weather_info/data/repositories/weather_info_repository.dart';

part 'weather_info_state.dart';

class WeatherInfoCubit extends Cubit<WeatherInfoState> {
  WeatherInfoCubit(this.WeatherInfoRepository) : super(WeatherInfoInitial());

  final WeatherInfoRepository;

  Future<void> getWeatherInfoOfCity(String city) async {
    emit(WeatherInfoLoading());
    final weatherInfo = await WeatherInfoRepository.getWeatherInfoOfCity(city);
    if (weatherInfo.containsKey('error')) {
      emit(WeatherInfoError(weatherInfo['error']));
    } else {
      emit(WeatherInfoLoaded(WeatherInfoModel.fromJson(weatherInfo)));
    }
  }

  Future<void> getWeatherInfoOfLocation(double lat, double lon) async {
    emit(WeatherInfoLoading());
    final weatherInfo = await WeatherInfoRepository.getWeatherInfoOfLocation(lat, lon);
    if (weatherInfo.containsKey('error')) {
      emit(WeatherInfoError(weatherInfo['error']));
    } else {
      emit(WeatherInfoLoaded(WeatherInfoModel.fromJson(weatherInfo)));
    }
  }
}
