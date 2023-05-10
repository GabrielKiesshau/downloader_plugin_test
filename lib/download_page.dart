import 'package:device_space/device_space.dart';
import 'package:downloader_plugin/downloader_plugin.dart';
import 'package:downloader_plugin/enums/base_directory.dart';
import 'package:downloader_plugin/enums/shared_storage.dart';
import 'package:downloader_plugin/enums/updates.dart';
import 'package:downloader_plugin/models/download_task.dart';
import 'package:downloader_plugin/models/task_progress_update.dart';
import 'package:downloader_plugin/models/task_status_update.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key, required this.title});

  final String title;

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  int _counter = 0;
  final fileDownloader = DownloaderPlugin();

  @override
  void initState() {
    super.initState();

    _getSpaceInfo();
    
    fileDownloader.updates.listen((update) async {
      if (update is TaskStatusUpdate) {
        debugPrint('Status update for ${update.task} with status ${update.status}');
        return;
      }

      if (update is TaskProgressUpdate) {
        if (update.progress == 1.0) {
          debugPrint('download complete');
          final x = await fileDownloader.moveToSharedStorage(
            update.task as DownloadTask,
            SharedStorage.downloads,
          );

          debugPrint(x);
        }
        debugPrint('Progress update for ${update.task} with progress ${update.progress}');
      }
    });
  }

  @override
  void dispose() async {
    fileDownloader.destroy();
    super.dispose();
  }

  void _getSpaceInfo() async {
    final deviceSpace = await getDeviceSpace();

    debugPrint('Human: Total: ${deviceSpace.totalSize}, Free: ${deviceSpace.freeSize}, Used: ${deviceSpace.usedSize}');
  }

  void _incrementCounter() async {
    if (!await fileDownloader.hasWritePermission()) {
      await fileDownloader.requestWritePermission();
    }

    if (await fileDownloader.hasWritePermission()) {
      final task = DownloadTask(
        url: 'https://google.com',
        filename: 'testfile.txt',
        baseDirectory: BaseDirectory.temporary,
        updates: Updates.statusAndProgress,
      );

      // final task = DownloadTask(
      //   url: 'https://t4.ftcdn.net/jpg/02/66/72/41/240_F_266724172_Iy8gdKgMa7XmrhYYxLCxyhx6J7070Pr8.jpg',
      //   filename: 'cat.jpg',
      //   baseDirectory: BaseDirectory.temporary,
      // );

      await fileDownloader.enqueue(task);

      setState(() {
        _counter++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
