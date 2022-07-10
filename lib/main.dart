import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:workmanager/workmanager.dart';
import 'package:auth_service/auth_service.dart';
import 'home/view/home_view.dart';
import 'login/view/login_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(callbackDispatcher);
  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case Workmanager.iOSBackgroundTask:
        await Firebase.initializeApp();
        Location location = new Location();
        location.enableBackgroundMode(enable: true);
        bool _serviceEnabled;
        PermissionStatus _permissionGranted;
        LocationData _locationData;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            break;
          }
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            break;
          }
        }
        _locationData = await location.getLocation();
        DateTime now = DateTime.now();

        await FirebaseFirestore.instance
            .collection('location')
            .doc("${FirebaseAuth.instance.currentUser?.email}")
            .collection("${now.year}年")
            .doc("${now.month}月")
            .collection("${now.day}日")
            .add({
          'latitude': double.parse(_locationData.latitude!.toStringAsFixed(7)),
          'longitude':
              double.parse(_locationData.longitude!.toStringAsFixed(7)),
          'occured_at': DateFormat('yyyy-MM-dd hh:mm:ss').format(now)
        });
        break;
    }
    bool success = true;
    return Future.value(success);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthService>().authState,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Trace Health Care',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: const Authenticate(),
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<User?>();

    if (authService != null) {
      return const HomeView();
    }
    return LoginView();
  }
}
