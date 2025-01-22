import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> university; // This will hold the university data

  const DetailsScreen({Key? key, required this.university}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(university['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              university['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Country: ${university['country']}'),
            SizedBox(height: 8),
            Text('Website: ${university['web_pages'].first}'),
            // Add any additional details you want to show here
          ],
        ),
      ),
    );
  }
}

