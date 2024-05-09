import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String apiKey = 'e71ddad70328f8a04078509f6d89c950';
  String city = 'Kozhikode'; 
  String weather = '';
  double temp = 0.0;
  bool isLoading = true;
  TextEditingController _controller = TextEditingController();
  


  @override
  void initState() {
    super.initState();
    fetchWeatherData(city);
  }

  Future<void> fetchWeatherData(String city) async {
    final response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric' as Uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        weather = data['weather'][0]['main'];
        temp = data['main']['temp'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  void updateWeather() {
    setState(() {
      isLoading = true;
    });
    fetchWeatherData(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Current Weather in $city',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Weather: $weather',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Temperature: $temp°C',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Enter City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: updateWeather,
                    child: Text('Search'),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}