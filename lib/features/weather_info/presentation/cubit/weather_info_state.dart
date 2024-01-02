part of 'weather_info_cubit.dart';

@immutable
abstract class WeatherInfoState {}

class WeatherInfoInitial extends WeatherInfoState {}

class WeatherInfoLoading extends WeatherInfoState {}

class WeatherInfoLoaded extends WeatherInfoState {
  final WeatherInfoModel weatherInfoModel;

  WeatherInfoLoaded(this.weatherInfoModel);
}

class WeatherInfoError extends WeatherInfoState {
  final String error;

  WeatherInfoError(this.error);
}
