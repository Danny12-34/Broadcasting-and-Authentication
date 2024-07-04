import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _musicFilePath = 'F:\DANNY\IYOBOKAMANA\INDIRIMBO\OTHERS\AUDIO\kimironko choir.aac'; // Replace with your music file path

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _playMusic,
              child: Text('Play Music'),
            ),
            ElevatedButton(
              onPressed: _pauseMusic,
              child: Text('Pause Music'),
            ),
            ElevatedButton(
              onPressed: _stopMusic,
              child: Text('Stop Music'),
            ),
            SizedBox(height: 20),
            Text(
              _isPlaying ? 'Music Playing' : 'Music Stopped',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _playMusic() async {
    int result = await _audioPlayer.play(_musicFilePath, isLocal: true);
    if (result == 1) {
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _pauseMusic() {
    _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _stopMusic() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }
}
