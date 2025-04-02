import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectedScreen extends StatelessWidget {
  final BluetoothDevice device;
  final BluetoothCharacteristic characteristic;

  const ConnectedScreen({
    super.key,
    required this.device,
    required this.characteristic,
  });

  void _sendCommand() async {
    final message = "READ";
    await characteristic.write(message.codeUnits);
    debugPrint('📤 Sent: $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connected to ESP32')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device: ${device.name}'),
            Text('UUID: ${characteristic.uuid}'),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _sendCommand,
                child: const Text('Request Random Message from ESP32'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
