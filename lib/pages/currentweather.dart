import 'package:flutter/material.dart';
import 'package:weather_app/pages/check%20code%20line.dart';
import 'package:weather_app/pages/worker.dart';
import 'package:weather_app/text_style/textstyle.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherPage extends StatefulWidget {
  final String city;

  const WeatherPage({Key? key, required this.city}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final Worker weatherService = Worker();
  Map<String, dynamic>? currentWeather;
  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cityController.text = widget.city;  // Initialize with the passed city
    _loadCurrentWeather(widget.city);   // Initial load with the provided city
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  void _loadCurrentWeather(String city) async {
    final weatherData = await weatherService.fetchCurrentWeather(city);
    setState(() {
      currentWeather = weatherData;
      // print("Current weather: $currentWeather");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Weather in ${cityController.text}'),
        backgroundColor: const Color(0xff1370F3),
      ),
      body: currentWeather == null
          ? Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff11ACFE), Color(0xff1370F3)])),
          child: const Center(child: CircularProgressIndicator()))
          : Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff11ACFE), Color(0xff1168F3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cityController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter city name",
                          ),
                        ),
                      ),
                      IconButton(
                        icon:
                        const Icon(Icons.search, color: Colors.blue),
                        onPressed: () {
                          // Trigger weather update with the search input
                          if (cityController.text.trim().isNotEmpty) {
                            _loadCurrentWeather(cityController.text);
                          } else {
                            // print("Search is blank");
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      "https://openweathermap.org/img/wn/${currentWeather!['icon']}@2x.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text('   ${currentWeather!['description']}',
                    style: TextStyles.headingText),
                SingleChildScrollView(
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyles.alteraheadingText,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                              '   ${(currentWeather!['temperature'] as double).toStringAsFixed(0)} ',
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(
                              text: ' °C',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(
                            WeatherIcons.humidity,
                            color: Colors.white,
                          ),
                          const Text('Humidity', style: TextStyles.normalText),
                          Text('${currentWeather!['humidity']}%',
                              style: TextStyles.normalText),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(
                            WeatherIcons.day_windy,
                            color: Colors.white,
                          ),
                          const Text('Wind Speed',
                              style: TextStyles.normalText),
                          Text('${currentWeather!['windSpeed']}',
                              style: TextStyles.normalText),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(
                            WeatherIcons.cloud,
                            color: Colors.white,
                          ),
                          const Text('Cloud', style: TextStyles.normalText),
                          Text('${currentWeather!['cloud']}',
                              style: TextStyles.normalText),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FiveDayForecastPage(
                            city: cityController.text),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff04286E)),
                  child: const Text(
                    'View 5-Day Forecast',
                    style: TextStyle(color: Color(0xffFDFDFD)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
