import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'barasanewton62@gmail.com', 
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Random Decision Maker Feedback',
      }),
    );

    try {
      if (!await launchUrl(emailLaunchUri)) {
        throw Exception('Could not launch $emailLaunchUri');
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  Future<void> _launchStore() async {
    // Replace with your actual package name when live
    final Uri url = Uri.parse('market://details?id=com.jumanewton.random_decision_maker');
    // Fallback URL for browser
    final Uri webUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.jumanewton.random_decision_maker');

    try {
      if (!await launchUrl(url)) {
        await launchUrl(webUrl);
      }
    } catch (e) {
       debugPrint('Error launching store: $e');
       await launchUrl(webUrl);
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 80,
            color: Colors.teal,
          ),
          const SizedBox(height: 20),
          const Text(
            'We\u2019d love to hear from you!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your feedback helps us make Random Decision Maker better. Let us know if you have any suggestions or issues.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),
          _buildActionCard(
            context,
            'Send Feedback',
            'Found a bug or have an idea?',
            Icons.email_outlined,
            Colors.blue,
            _launchEmail,
          ),
          const SizedBox(height: 20),
          _buildActionCard(
            context,
            'Rate the App',
            'Enjoying the app? Leave a review!',
            Icons.star_outline_rounded,
            Colors.amber,
            _launchStore,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
