import 'package:downloader_plugin_test/download_page.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: MaterialButton(
          color: Colors.green,
          child: const Text('hello'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DownloadPage(title: 'Download'),
            ),
          ),
        ),
      ),
    );
  }
}