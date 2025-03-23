import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactButton extends StatelessWidget {
  final String label;
  final String url;
  final IconData icon;

  const ContactButton({super.key, required this.label, required this.url, required this.icon});

  Future<void> _launchUrl() async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print("Không thể mở: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _launchUrl,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
