import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/core/theme/text_theme.dart';

import '../../../../core/api_config.dart';
import '../../data/models/weather_info_model.dart';
import '../cubit/weather_info_cubit.dart';
import '../pages/weather_details_page.dart';

/// Window with basic weather info
class LoadedWeatherDataWidget extends StatelessWidget {
  const LoadedWeatherDataWidget({super.key, required this.cityTextController, required this.weatherInfo});

  final TextEditingController cityTextController;
  final WeatherInfoModel weatherInfo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 550,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show city name
            Text(
                cityTextController.text != ""
                    ? cityTextController.text
                    : weatherInfo.name,
                style: displaysmall.copyWith(
                    color:
                    Theme.of(context).colorScheme.onTertiaryContainer)),
            const SizedBox(height: 12),
            // Show weather icon
            Image.network(iconURL(weatherInfo.weather[0].icon)),
            const SizedBox(height: 12),
            // Show weather description
            Text(weatherInfo.weather[0].description,
                style: headlinemedium.copyWith(
                    color:
                    Theme.of(context).colorScheme.onTertiaryContainer)),
            const SizedBox(height: 20),
            // Show temperature
            Text("${weatherInfo.main.temp}°C",
                style: headlinelarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                    Theme.of(context).colorScheme.onTertiaryContainer)),
            const SizedBox(height: 14),
            // Show temperature as feels like
            Text("Відчувається як ${weatherInfo.main.feelsLike}°C",
                style: titlemedium.copyWith(
                    color:
                    Theme.of(context).colorScheme.onTertiaryContainer)),
            const SizedBox(height: 14),
            // Show visibility distance
            Text("Видимість ${weatherInfo.visibility / 1000} км",
                style: titlesmall.copyWith(
                    color:
                    Theme.of(context).colorScheme.onTertiaryContainer)),
            const SizedBox(height: 14),
            // Show last time of weather info update
            Text(
                "Час оновлення: ${DateTime.fromMillisecondsSinceEpoch(weatherInfo.dt * 1000).toLocal()}",
                style: bodymedium.copyWith(
                    color:
                    Theme.of(context).colorScheme.onTertiaryContainer)),
            const SizedBox(height: 20),
            // Button to make new request
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color:
                      Theme.of(context).colorScheme.onTertiaryContainer),
                ),
                onPressed: () {
                  // Clear text field and emit initial state
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherDetailsPage(cityTextController: cityTextController,)));
                  cityTextController.clear();
                },
                child: Text("Детальніше",
                    style: bodymedium.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onTertiaryContainer))),
          ],
        ),
      ),
    );
  }
}
