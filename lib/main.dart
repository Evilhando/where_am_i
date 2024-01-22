import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Position _currentLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Position? location = await getCurrentLocation();
    if (location != null) {
      await sendLocationToApi(location);

      String address = await getAddressFromCoordinates(
        location.latitude,
        location.longitude,
      );

      print('Aktuelle Adresse: $address');
    }
    setState(() {
      _currentLocation = location!;
    });
  }

  Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  Future<void> sendLocationToApi(Position location) async {
    String apiUrl = '';
    Map<String, dynamic> data = {
      "latitude": location.latitude,
      "longitude": location.longitude,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: data,
      );

      if (response.statusCode == 200) {
        print("Location sent successfully");
      } else {
        print("Failed to send location. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending location: $e");
    }
  }

  Future getAddressFromCoordinates(double latitude, double longitude) async {
    const apiUrl = 'https://api.opencagedata.com/geocode';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final results = decodedResponse['results'];
        if (results.isNotEmpty) {
          final formattedAddress = results[0]['formatted'];
          return formattedAddress;
        }
      }
    } catch (e) {
      print('Error retrieving address: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Where Am I App"),
      ),
      body: Center(
        // ignore: unnecessary_null_comparison
        child: _currentLocation != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Latitude: ${_currentLocation.latitude}"),
                  Text("Longitude: ${_currentLocation.longitude}"),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
