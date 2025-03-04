import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  int _initialTime = 1500;
  int _remainingTime = 1500;
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int get initialTime => _initialTime;
  int get remainingTime => _remainingTime;
  bool get isRunning => _isRunning;

  void startTimer() {
    if (_timer != null || _remainingTime == 0) return;
    _isRunning = true;
    _isPaused = false;
    notifyListeners();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_remainingTime > 0) {
        _remainingTime--;
        await _audioPlayer.setVolume(1.0);
        await _playMusic();
        notifyListeners();
      } else {
        _timer?.cancel();
        _timer = null;
        _remainingTime = _initialTime;
        _isRunning = false;
        await _audioPlayer.stop();
        notifyListeners();
      }
    });
  }

  Future<void> _playMusic() async {
    if (_isPaused) return;
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('nature.mp3'));
  }

  void pauseTimer() async {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = true;
    await _audioPlayer.pause();
    notifyListeners();
  }

  void resetTimer() async {
    _timer?.cancel();
    _timer = null;
    _remainingTime = _initialTime;
    _isRunning = false;
    _isPaused = false;
    await _audioPlayer.stop();
    notifyListeners();
  }

  void setTime(int second) {
    _remainingTime = second;
    _initialTime = second;
    notifyListeners();
  }
}
