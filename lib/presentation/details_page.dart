// // import 'package:flutter/material.dart';

// // class DetailsScreen extends StatelessWidget {
// //   final Map<String, dynamic> university; // This will hold the university data

// //   const DetailsScreen({Key? key, required this.university}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(university['name']),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               university['name'],
// //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 8),
// //             Text('Country: ${university['country']}'),
// //             SizedBox(height: 8),
// //             Text('Website: ${university['web_pages'].first}'),
// //             // Add any additional details you want to show here
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// class DetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> university; // This will hold the university data

//   const DetailsScreen({Key? key, required this.university}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(university['name']),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               university['name'],
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text('Country: ${university['country']}'),
//             const SizedBox(height: 8),
//             if (university['web_pages'] != null &&
//                 university['web_pages'].isNotEmpty)
//               Text('Website: ${university['web_pages'].first}'),
//             if (university['domains'] != null &&
//                 university['domains'].isNotEmpty)
//               Text('Domain: ${university['domains'].first}'),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> university;

  const DetailsScreen({Key? key, required this.university}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(university['name'] ?? 'University Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  university['name'] ?? 'N/A',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF29292A)),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                    context, 'Country', university['country'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow(
                    context, 'State/Province', university['state'] ?? 'N/A'),
                const SizedBox(height: 16),
                if (university['website'] != null &&
                    university['website'].isNotEmpty)
                  _buildClickableWebsite(
                      context, university['website'] ?? 'N/A'),
                const SizedBox(height: 16),
                // Add more details if needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF29292A),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(color: Color(0xFF29292A))),
        ),
      ],
    );
  }

  Widget _buildClickableWebsite(BuildContext context, String website) {
    return InkWell(
      onTap: () {
        _launchURL(context, website); // Pass context here
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Website:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF29292A),
            ),
          ),
          Text(
            website,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {  //accept context here
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch URL'),
        ),
      );
    }
  }
}