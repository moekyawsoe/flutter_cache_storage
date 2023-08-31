import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String musicUrl;

  MusicPlayerScreen({required this.musicUrl});

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  late File file;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    file = File('');
  }

  Future<void> _initCache() async {
    try {
      // _requestPermissions();
      await Permission.manageExternalStorage.request();
      var status = await Permission.manageExternalStorage.status;
      if (status.isGranted) {
        // Cache the music file
        file = await DefaultCacheManager().getSingleFile(widget.musicUrl);

        setState(() {
          print("downloaded file path");
          print(file.path);
        });
      }else{
        print("not permission");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _playMusic() {
    _initCache();
    if (file.path.isNotEmpty) {
      var urlSource = DeviceFileSource(file.path);
      _audioPlayer.play(urlSource);
    }else{
      print("cache file is empty");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _playMusic,
              child: Text('Play Music'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MusicPlayerScreen(
      musicUrl: 'http://192.168.20.80/assets/audio.wav',
    ),
  ));
}



