import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart'; // Import for audioplayers package
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Connectivity _connectivity;
  late Battery _battery;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late StreamSubscription<BatteryState> _batterySubscription;
  late bool _isConnected;
  late int _batteryLevel;
  late ThemeMode _themeMode;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AudioPlayer _audioPlayer; // Initialize AudioPlayer instance

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _battery = Battery();
    _isConnected = false;
    _batteryLevel = 0;
    _themeMode = ThemeMode.light;
    _audioPlayer = AudioPlayer(); // Initialize AudioPlayer
    _initConnectivity();
    _initBattery();
    _loadTheme();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _batterySubscription.cancel();
    _audioPlayer.dispose(); // Dispose AudioPlayer
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
      _showToast(_isConnected ? 'Connected to the Internet' : 'No Internet Connection');
    });
    ConnectivityResult result = await _connectivity.checkConnectivity();
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  void _initBattery() {
    _batterySubscription = _battery.onBatteryStateChanged.listen((state) async {
      int batteryLevel = await _battery.batteryLevel;
      setState(() {
        _batteryLevel = batteryLevel;
      });

      if (state == BatteryState.charging && batteryLevel >= 90) {
        _ringDevice();
      } else {
        _stopRing();
      }
    });
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = prefs.getBool('isDarkMode') == true ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    });
  }

  void _ringDevice() async {
    await _audioPlayer.play('F:/DANNY/IYOBOKAMANA/INDIRIMBO/OTHERS/AUDIO/kimironko.aac');
    await Future.delayed(Duration(milliseconds: 500));
    await _audioPlayer.stop();
  }

  void _stopRing() async {
    await _audioPlayer.stop();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _showToast('Signed in successfully');
    } catch (e) {
      print('SignIn Error: $e');
      _showToast('Sign in failed');
    }
  }

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _showToast('Signed up successfully');
    } catch (e) {
      print('SignUp Error: $e');
      _showToast('Sign up failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integrated Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: _themeMode == ThemeMode.light ? Brightness.light : Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Integrated Flutter App'),
          actions: [
            IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _isConnected ? 'Connected to Internet' : 'No Internet Connection',
                style: TextStyle(
                  fontSize: 40,
                  color: _isConnected ? Color.fromARGB(255, 59, 255, 128) : Colors.red,
                ),
              ),
              SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Battery Level: $_batteryLevel%',
                      style: TextStyle(fontSize: 40),
                    ),
                    TextSpan(
                      text: '\n${_batteryLevel > 90 ? 'Your battery is at risk' : 'Your battery is in good condition'}',
                      style: TextStyle(
                        fontSize: 20,
                        color: _batteryLevel > 90 ? Colors.red : Color.fromARGB(255, 2, 98, 26),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: '                                                              Email'),
                  ),
                  SizedBox(height: 10),
                
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: '                                                              Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _signInWithEmailAndPassword,
                        child: Text('SignIn'),
                      ),
                      ElevatedButton(
                        onPressed: _signUpWithEmailAndPassword,
                        child: Text('SignUp'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
