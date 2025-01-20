import 'dart:async';
import 'package:flutter/material.dart';
import 'corrida_atual.dart';
import 'gps.dart';
import 'widgets.dart';
import 'appbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Corrida corrida = Corrida();
  final GpsService gpsService = GpsService();
  bool isRunning = false;
  Duration elapsedTime = Duration();

  late Timer _elapsedTimeTimer;

  @override
  void initState() {
    super.initState();
  }

  // Start GPS and elapsed time tracking
  void _startRun() {
    setState(() {
      isRunning = true;
    });

    gpsService.startGps((location) {
      // Update Corrida data here with the new GPS coordinates
      corrida.push_coordenadas(location.latitude!, location.longitude!, DateTime.now());
    });

    // Start the elapsed time timer
    _elapsedTimeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime = Duration(seconds: elapsedTime.inSeconds + 1);
      });
    });
  }

  // Stop GPS and elapsed time tracking
  void _stopRun() {
    setState(() {
      isRunning = false;
    });

    gpsService.stopGps();
    _elapsedTimeTimer.cancel();
  }

  @override
  void dispose() {
    if (_elapsedTimeTimer.isActive) {
      _elapsedTimeTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            WidgetPaceMedio(paceMedio: corrida.pace_medio),
            WidgetElapsedTime(isRunning: isRunning, elapsedTime: elapsedTime),
            WidgetPaceInstantaneo(paceInstantaneo: corrida.pace_instantaneo),
            //WidgetPaceMaisRapido(paceMaisRapido: corrida.pace_mais_rapido),
            ],),

            WidgetDistanciaTotal(distanciaTotal: corrida.distancia_total),

            // Start/Stop buttons
            SizedBox(height: 20),
            isRunning
                ? ElevatedButton(
                    onPressed: _stopRun,
                    child: Icon(Icons.stop),
                  )
                : ElevatedButton(
                    onPressed: _startRun,
                    child: Icon(Icons.play_arrow),
                  ),
          ],
        ),
      ),
    );
  }
}
