import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:squashy/widgets/location_input.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/squash.png',
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              'Squashy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 64),
            Text(
              'This simple app helps users track squash matches, collect statistics and receive notifications about upcoming events.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            LocationInput(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Developed by mat183',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(SimpleIcons.github),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
