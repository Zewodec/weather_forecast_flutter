import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/core/theme/text_theme.dart';
import 'package:weather_forecast/features/weather_info/data/models/weather_info_model.dart';
import 'package:weather_forecast/features/weather_info/presentation/cubit/weather_info_cubit.dart';

class WeatherDetailsPage extends StatelessWidget {
  const WeatherDetailsPage({super.key, required this.cityTextController});

  final TextEditingController cityTextController;

  @override
  Widget build(BuildContext context) {
    WeatherInfoModel? weatherInfo;
    if (context.read<WeatherInfoCubit>().state is WeatherInfoLoaded) {
      weatherInfo =
          (context.read<WeatherInfoCubit>().state as WeatherInfoLoaded)
              .weatherInfoModel;
    } else {
      Navigator.of(context).pop();
      return const SizedBox.shrink();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text(
            'Погода у ${cityTextController.text == "" ? weatherInfo.name : cityTextController.text}'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // Show coordinates
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Координати: ${weatherInfo.coord.lat}, ${weatherInfo.coord.lon}",
                  style: titlemedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer)),
            ),
            // Show Weather info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Погода: ${weatherInfo.weather[0].description}",
                  style: titlemedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer)),
            ),
            // Show base
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("База: ${weatherInfo.base}",
                  style: titlemedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer)),
            ),
            // Show main info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Температура: ${weatherInfo.main.temp}°C\n"
                  "Відчувається як: ${weatherInfo.main.feelsLike}°C\n"
                  "Мінімальна температура: ${weatherInfo.main.tempMin}°C\n"
                  "Максимальна температура: ${weatherInfo.main.tempMax}°C\n"
                  "Атмосферний тиск: ${weatherInfo.main.pressure} гПа\n"
                  "Вологість: ${weatherInfo.main.humidity} %\n"
                  "Атмосферний тиск на рівні моря: ${weatherInfo.main.seaLevel} гПа\n"
                  "Атмосферний тиск на рівні землі: ${weatherInfo.main.grndLevel} гПа",
                  style: titlemedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer)),
            ),
            // Show visibility distance
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Видимість: ${weatherInfo.visibility / 1000} км",
                  style: titlemedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer)),
            ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Швидкість вітру: ${weatherInfo.wind!.speed} м/с\n"
                    "Напрямок вітру: ${weatherInfo.wind!.deg}°",
                    style: titlemedium.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer)),
              ),
            // Show clouds info if available
            if (weatherInfo.clouds != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Хмарність: ${weatherInfo.clouds!.all} %",
                    style: titlemedium.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer)),
              ),
            // Show rain info if available
            if (weatherInfo.rain != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Кількість опадів: ${weatherInfo.rain!.the1H} мм",
                    style: titlemedium.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer)),
              ),
            // Show datetime
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Час оновлення: ${DateTime.fromMillisecondsSinceEpoch(weatherInfo.dt * 1000).toLocal()}",
                  style: titlemedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer)),
            ),
            // Show sys info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Країна: ${weatherInfo.sys!.country}\n"
                  "Схід сонця: ${DateTime.fromMillisecondsSinceEpoch(weatherInfo.sys.sunrise! * 1000).toLocal()}\n"
                  "Захід сонця: ${DateTime.fromMillisecondsSinceEpoch(weatherInfo.sys.sunset! * 1000).toLocal()}",
                  style: titlemedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer)),
            ),
            // Show timezone
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Часовий пояс: ${weatherInfo.timezone}",
                  style: titlemedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer)),
            ),
            // Show city name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Місто: ${weatherInfo.name}",
                  style: titlemedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer)),
            ),
          ],
        ),
      ),
    );
  }
}
