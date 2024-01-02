import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/core/api_config.dart';
import 'package:weather_forecast/core/theme/text_theme.dart';
import 'package:weather_forecast/core/theme/theme.dart';
import 'package:weather_forecast/features/weather_info/data/models/weather_info_model.dart';
import 'package:weather_forecast/features/weather_info/data/repositories/weather_info_repository.dart';
import 'package:weather_forecast/features/weather_info/presentation/cubit/weather_info_cubit.dart';
import 'package:weather_forecast/features/weather_info/presentation/cubit/weather_info_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      theme: MaterialTheme(textTheme)
          .theme(MaterialTheme.lightMediumContrastScheme().toColorScheme()),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) =>
            const MyHomePage(title: 'Current Weather Forecast'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Initiate cubit and text controller
  WeatherInfoCubit weatherInfoCubit = WeatherInfoCubit(WeatherInfoRepository());
  final TextEditingController _cityTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: BlocConsumer<WeatherInfoCubit, WeatherInfoState>(
            bloc: weatherInfoCubit,
            listener: (context, state) {
              // Show error message if error occurred
              if (state is WeatherInfoError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error,
                        style: bodysmall.copyWith(
                            color: Theme.of(context).colorScheme.onError)),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              // Show basic window on Initial state
              if (state is WeatherInfoInitial) {
                return _buildInitialWindow();
              } else if (state is WeatherInfoLoading) {
                // Show loading indicator when loading
                return const Center(child: CircularProgressIndicator());
              } else if (state is WeatherInfoLoaded) {
                // Show loaded weather info
                return _buildLoadedWeatherInfoWindow(state.weatherInfoModel);
              } else {
                // Show basic window on other states (error state also)
                return _buildInitialWindow();
              }
            },
          ),
        ),
      ),
    );
  }

  /// Window with text field for city name input
  Widget _buildInitialWindow() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Введіть місто для отримання інформації про погоду",
                style: bodymedium),
            const SizedBox(height: 20),
            TextField(
              controller: _cityTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Місто',
              ),
              onSubmitted: (value) {
                // Get weather info on submit button on keyboard
                weatherInfoCubit.getWeatherInfoOfCity(value.trim());
              },
            ),
          ],
        ),
      );

  /// Window with basic weather info
  Widget _buildLoadedWeatherInfoWindow(WeatherInfoModel weatherInfo) => Center(
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
              Text(_cityTextController.text,
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
                      color: Theme.of(context).colorScheme.onSurface)),
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
                    weatherInfoCubit.emit(WeatherInfoInitial());
                    _cityTextController.clear();
                  },
                  child: Text("Зробити новий запит",
                      style: bodymedium.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer))),
            ],
          ),
        ),
      );
}
