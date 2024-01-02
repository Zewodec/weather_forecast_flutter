import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_forecast/core/api_config.dart';
import 'package:weather_forecast/features/weather_info/data/models/weather_info_model.dart';

class WeatherInfoRepository{
  Dio dio = Dio();

  Future<Map<String, dynamic>> getWeatherInfoOfCity(String city) async {
    try {
      final response = await dio.get(
        '${weatherPoint}?q=$city&appid=$appid&lang=$lang&units=metric',
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {'error': 'Щось пішло не так. Перевірте з\'єднання, будь ласка, або спробуйте пізніше!'};
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      return e.response?.statusCode == 404
          ? {'error': 'Місто не знайдено'}
          : {'error': "Щось пішло не так. Перевірте з'єднання, будь ласка!"};
    }
  }

  Future<Map<String, dynamic>> getWeatherInfoOfLocation(double lat, double lon) async {
    try {
      final response = await dio.get(
        '${weatherPoint}?lat=$lat&lon=$lon&appid=$appid&lang=$lang&units=metric',
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {'error': 'Щось пішло не так. Перевірте з\'єднання, будь ласка, або спробуйте пізніше!'};
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      return e.response?.statusCode == 404
          ? {'error': 'Місто не знайдено'}
          : {'error': "Щось пішло не так. Перевірте з'єднання, будь ласка!"};
    }
  }
}