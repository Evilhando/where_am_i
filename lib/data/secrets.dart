// lib/main.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secrets.dart'; // Importieren Sie die Datei mit dem API-Schlüssel

// ...

Future<String> getAddressFromCoordinates(
    double latitude, double longitude) async {
  final apiUrl =
      'https://api.opencagedata.com/geocode/v1/json?key=$opencageApiKey&q=$latitude+$longitude&pretty=1';

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
