import 'package:flutter/material.dart';
import 'dart:async';

class StatColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatColumn({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.greenAccent),
        SizedBox(height: 8),
        Text(label),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}


// Widget for displaying instantaneous pace
class WidgetPaceInstantaneo extends StatelessWidget {
  final double paceInstantaneo;

  WidgetPaceInstantaneo({required this.paceInstantaneo});

  @override
  Widget build(BuildContext context) {
    return _buildInfoCard(
      'Pace Instantâneo',
      '${paceInstantaneo.toStringAsFixed(2)} min/km',
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return StatColumn(
              icon: Icons.speed,
              label: title,
              value: value,
            );
  }
}

// Widget for displaying average pace
class WidgetPaceMedio extends StatelessWidget {
  final double paceMedio;

  WidgetPaceMedio({required this.paceMedio});

  @override
  Widget build(BuildContext context) {
    return _buildInfoCard(
      'Pace Médio',
      '${paceMedio.toStringAsFixed(2)} min/km',
    );
  }

Widget _buildInfoCard(String title, String value) {
    return StatColumn(
              icon: Icons.timer,
              label: title,
              value: value,
            );
  }
}

// Widget for displaying total distance
class WidgetDistanciaTotal extends StatelessWidget {
  final double distanciaTotal;

  WidgetDistanciaTotal({required this.distanciaTotal});

  @override
  Widget build(BuildContext context) {
    return _buildInfoCard(
      'Distância Total',
      distanciaTotal.toStringAsFixed(2),
    );
  }

Widget _buildInfoCard(String title, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 80, fontWeight: FontWeight.w500)),
        Text("KM")
      ]
    );
  }
}

// Widget for displaying fastest pace
class WidgetPaceMaisRapido extends StatelessWidget {
  final double paceMaisRapido;

  WidgetPaceMaisRapido({required this.paceMaisRapido});

  @override
  Widget build(BuildContext context) {
    return _buildInfoCard(
      'Pace Mais Rápido',
      '${paceMaisRapido.toStringAsFixed(2)} min/km',
    );
  }

Widget _buildInfoCard(String title, String value) {
    return StatColumn(
              icon: Icons.timer,
              label: title,
              value: value,
            );
  }
}

// Widget for displaying elapsed time
class WidgetElapsedTime extends StatefulWidget {
  final bool isRunning;
  final Duration elapsedTime;

  WidgetElapsedTime({required this.isRunning, required this.elapsedTime});

  @override
  _WidgetElapsedTimeState createState() => _WidgetElapsedTimeState();
}

class _WidgetElapsedTimeState extends State<WidgetElapsedTime> {
  Timer? _timer;  // Make _timer nullable
  Duration _currentTime = Duration();

  @override
  void initState() {
    super.initState();
    if (widget.isRunning) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant WidgetElapsedTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning && _timer == null) {
      _startTimer();
    } else if (!widget.isRunning && _timer != null) {
      _stopTimer();
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _stopTimer();
    }
    super.dispose();
  }

  // Start the timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = Duration(seconds: _currentTime.inSeconds + 1);
      });
    });
  }

  // Stop the timer
  void _stopTimer() {
    _timer?.cancel();  // Safe cancel if _timer is not null
    _timer = null;  // Set _timer to null after stopping
  }

  @override
  Widget build(BuildContext context) {
    final hours = _currentTime.inHours.toString().padLeft(2, '0');
    final minutes = (_currentTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_currentTime.inSeconds % 60).toString().padLeft(2, '0');

    return _buildInfoCard(
      'Tempo Decorrido',
      '$hours:$minutes:$seconds',
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return StatColumn(icon: Icons.access_time, label: title, value: value);

  }
}
