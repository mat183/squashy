import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:squashy/screens/map.dart';

const lat = 51.10874477213786;
const lng = 17.002287916839123;
final String apiKey = dotenv.env['GOOGLE_API_KEY']!;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<StatefulWidget> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _address = '';

  String get locationImage {
    // return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$apiKey';
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=15&size=600x300&maptype=roadmap&key=$apiKey';
  }

  void _showMap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(
          latitude: lat,
          longitude: lng,
        ),
      ),
    );
  }

  Future<void> _fetchLocationAddress() async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Something went wrong during http request');
    }

    final data = jsonDecode(response.body);
    final address = data['results'][0]['formatted_address'];

    setState(() {
      _address = address;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchLocationAddress();
  }

  @override
  Widget build(BuildContext context) {
    Widget locationPreview = Image.network(
      locationImage,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );

    return Column(
      children: [
        Text(
          'Location: $_address',
          style: TextStyle(fontSize: 14),
        ),
        GestureDetector(
          onTap: () => _showMap(context),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            height: 300,
            width: double.infinity,
            child: locationPreview,
          ),
        ),
      ],
    );
  }
}
