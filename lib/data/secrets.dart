import 'dart:convert';

import 'package:http/http.dart' as http;

// ...

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
