import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final Uri _url = Uri.parse('https://github.com/vedantjain8/coin-keeper');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
                "Hello! This is the developer of this app. Hope so you are enjoing this app. For any bugs and issue reporting create a new issue on the github repo. Thank You!"),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _openURL,
              child: const Text("Github Source Code"),
            ),
          ],
        ),
      ),
    );
  }

  void _openURL() async {
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $_url';
    }
  }
}
