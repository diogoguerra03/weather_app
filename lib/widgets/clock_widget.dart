import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late String _formattedTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime(); // Initialize the time immediately
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );
  }

  void _updateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yy HH:mm:ss');
    setState(() {
      _formattedTime = formatter.format(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formattedTime,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
