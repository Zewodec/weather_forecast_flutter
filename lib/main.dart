import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:weather_forecast/core/theme/text_theme.dart';
import 'package:weather_forecast/core/theme/theme.dart';
import 'package:weather_forecast/features/weather_info/data/repositories/weather_info_repository.dart';
import 'package:weather_forecast/features/weather_info/presentation/cubit/weather_info_cubit.dart';
import 'package:weather_forecast/features/weather_info/presentation/widgets/get_weather_by_city_widget.dart';
import 'package:weather_forecast/features/weather_info/presentation/widgets/loaded_weather_data_widget.dart';

import 'features/weather_info/presentation/pages/weather_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeatherInfoCubit>(
      create: (context) => WeatherInfoCubit(WeatherInfoRepository()),
      child: MaterialApp(
        title: 'Weather Forecast',
        theme: MaterialTheme(textTheme)
            .theme(MaterialTheme.lightMediumContrastScheme().toColorScheme()),
        darkTheme: MaterialTheme(textTheme)
            .theme(MaterialTheme.darkScheme().toColorScheme()),
        home: const MyHomePage(title: 'Current Weather Forecast'),
      ),
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
  // Initiate text controller
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
              // bloc: weatherInfoCubit,
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
                  return GetWeatherByCityWidget(
                      cityTextController: _cityTextController);
                } else if (state is WeatherInfoLoading) {
                  // Show loading indicator when loading
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeatherInfoLoaded) {
                  // Show loaded weather info
                  return LoadedWeatherDataWidget(
                      cityTextController: _cityTextController,
                      weatherInfo: state.weatherInfoModel);
                } else {
                  // Show basic window on other states (error state also)
                  return GetWeatherByCityWidget(
                      cityTextController: _cityTextController);
                }
              },
            ),
          ),
        ),
        floatingActionButton: BlocBuilder<WeatherInfoCubit, WeatherInfoState>(
          builder: (context, state) {
            if (state is WeatherInfoLoaded) {
              return FloatingActionButton(
                onPressed: () {
                  // Go to input city name window
                  _cityTextController.clear();
                  context.read<WeatherInfoCubit>().emit(WeatherInfoInitial());
                },
                tooltip: 'Дізнатись погоду в іншому місті',
                child: const Icon(Icons.search),
              );
            } else {
              return FloatingActionButton(
                onPressed: () async {
                    _cityTextController.clear();
                  context
                      .read<WeatherInfoCubit>()
                      .emit(WeatherInfoLoading()); // Show loading state
                  LocationData? location = await getUserLocationData(
                      context); // Get user location data
                  if (LocationData != null) {
                    // If location data is not null - get weather info
                    context.read<WeatherInfoCubit>().getWeatherInfoOfLocation(
                        location?.latitude, location?.longitude);
                  } else {
                    // If location data is null - show error message
                    context.read<WeatherInfoCubit>().emit(WeatherInfoInitial());
                    Fluttertoast.showToast(
                        msg: "Не вдалося отримати дані про місцезнаходження",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer,
                        textColor:
                            Theme.of(context).colorScheme.onErrorContainer);
                  }
                },
                tooltip: 'Дізнатись погоду по моєму місцезнаходженню',
                child: const Icon(Icons.my_location),
              );
            }
          },
        ));
  }
}

/// Function for getting user location data
Future<LocationData?> getUserLocationData(BuildContext context) async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;

  // Check if location service is enabled
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      // If service is not enabled - show error message
      Fluttertoast.showToast(
          msg: "Сервіс геолокації не включено!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          textColor: Theme.of(context).colorScheme.onErrorContainer);
      return null;
    }
  }

  // Check if location permission is granted
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      // If permission is not granted - show error message
      Fluttertoast.showToast(
          msg: "Доступ до геолокації не надано!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          textColor: Theme.of(context).colorScheme.onErrorContainer);
      return null;
    }
  }

  return await location.getLocation();
}
