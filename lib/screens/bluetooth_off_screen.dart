import 'package:flutter/material.dart';

class BluetoothOffScreen extends StatelessWidget {
  final dynamic adapterState; // Change type if you know it

  const BluetoothOffScreen({super.key, required this.adapterState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth Off')),
      body: Center(
        child: Text('Bluetooth is off: $adapterState'),
      ),
    );
  }
}

