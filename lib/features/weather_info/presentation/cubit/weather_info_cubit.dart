import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_forecast/features/weather_info/data/models/weather_info_model.dart';
import 'package:weather_forecast/features/weather_info/data/repositories/weather_info_repository.dart';

part 'weather_info_state.dart';

class WeatherInfoCubit extends Cubit<WeatherInfoState> {
  WeatherInfoCubit(this.WeatherInfoRepository) : super(WeatherInfoInitial());

  /// Repository for getting weather info
  final WeatherInfoRepository;

  Future<void> getWeatherInfoOfCity(String city) async {
    emit(WeatherInfoLoading());
    final weatherInfo = await WeatherInfoRepository.getWeatherInfoOfCity(city);
    await Future.delayed(const Duration(milliseconds: 500));
    if (weatherInfo.containsKey('error')) {
      emit(WeatherInfoError(weatherInfo['error']));
    } else {
      emit(WeatherInfoLoaded(WeatherInfoModel.fromJson(weatherInfo)));
    }
  }

  Future<void> getWeatherInfoOfLocation(double? lat, double? lon) async {
    if (lat == null || lon == null) {
      emit(WeatherInfoError('Не вдалося отримати дані про місцезнаходження'));
      return;
    }

    emit(WeatherInfoLoading());
    final weatherInfo = await WeatherInfoRepository.getWeatherInfoOfLocation(lat, lon);
    await Future.delayed(const Duration(milliseconds: 500));
    if (weatherInfo.containsKey('error')) {
      emit(WeatherInfoError(weatherInfo['error']));
    } else {
      emit(WeatherInfoLoaded(WeatherInfoModel.fromJson(weatherInfo)));
    }
  }
}
