import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/core/theme/text_theme.dart';

import '../cubit/weather_info_cubit.dart';

/// Window with text field for city name input
class GetWeatherByCityWidget extends StatelessWidget {
  const GetWeatherByCityWidget({super.key, required this.cityTextController});

  final TextEditingController cityTextController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Введіть місто для отримання інформації про погоду",
              style: bodymedium),
          const SizedBox(height: 20),
          TextField(
            controller: cityTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Місто',
            ),
            onSubmitted: (value) {
              // Get weather info on submit button on keyboard
              context.read<WeatherInfoCubit>().getWeatherInfoOfCity(value.trim());
            },
          ),
        ],
      ),
    );
  }
}
