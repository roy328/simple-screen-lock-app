import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lock Screen Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLocked = false;
  Timer? _timer;
  
  // Set default lock duration
  final int _lockDuration = 120;

  String getDurationString(int seconds) {
    int minutes = seconds ~/ 60;
    return '$minutes min';
  }

  void _lockScreen() {
    setState(() {
      _isLocked = true;
    });
    // Unlock after the specified duration
    _timer = Timer(Duration(seconds: _lockDuration), _unlockScreen);
  }

  void _unlockScreen() {
    setState(() {
      _isLocked = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300], // Smooth gray background
        child: Center(
          child: _isLocked
              ? LockScreen(onUnlock: _unlockScreen, lockDuration: _lockDuration)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Home Screen', style: TextStyle(fontSize: 24, color: Colors.black)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _lockScreen,
                      child: Text('Lock Screen for ${getDurationString(_lockDuration)}'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class LockScreen extends StatelessWidget {
  final VoidCallback onUnlock;
  final int lockDuration;

  LockScreen({required this.onUnlock, required this.lockDuration});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
              ),
              onPressed: () {
                // Add any action if needed when the Locked button is pressed
              },
              child: Text(
                'Locked',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            SizedBox(height: 20), // Space between button and time display
            Text(
              'Time Remaining:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 5),
            CountDownTimerDisplay(duration: lockDuration, onUnlock: onUnlock),
          ],
        ),
      ),
    );
  }
}

// Countdown Dialog Widget
class CountDownTimerDisplay extends StatefulWidget {
  final int duration;
  final VoidCallback onUnlock;

  CountDownTimerDisplay({required this.duration, required this.onUnlock});

  @override
  _CountDownTimerDisplayState createState() => _CountDownTimerDisplayState();
}

class _CountDownTimerDisplayState extends State<CountDownTimerDisplay> {
  late int _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        widget.onUnlock(); // Unlock after waiting
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
      style: TextStyle(fontSize: 48, color: Colors.redAccent, fontWeight: FontWeight.bold),
    );
  }
}