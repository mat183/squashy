import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  Future<void> _navigate() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service is not enabled!');
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        throw Exception('Location permission has not been granted!');
      }
    }

    final googleMapsUrl =
        Uri.parse('google.navigation:q=$latitude,$longitude&mode=d');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      final fallbackUrl = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&origin=My+Location&destination=$latitude,$longitude&travelmode=driving');
      await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.map_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _navigate,
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('m1'),
            position: LatLng(latitude, longitude),
          ),
        },
      ),
    );
  }
}
