import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'connected_screen.dart';


class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final List<ScanResult> _scanResults = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    _scanResults.clear();
    _scanSubscription?.cancel();

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        for (final result in results) {
          if (!_scanResults.any((r) => r.device.id == result.device.id)) {
            _scanResults.add(result);
          }
        }
      });
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5)).then((_) {
      setState(() => _isScanning = false);
    });

    setState(() => _isScanning = true);
  }

  void _stopScan() {
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
    setState(() => _isScanning = false);
  }

  @override
  void dispose() {
    _stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Devices'),
        actions: [
          IconButton(
            icon: Icon(_isScanning ? Icons.stop : Icons.refresh),
            onPressed: _isScanning ? _stopScan : _startScan,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _scanResults.length,
        itemBuilder: (context, index) {
          final result = _scanResults[index];
          return ListTile(
            leading: const Icon(Icons.bluetooth),
            title: Text(result.device.name.isNotEmpty
                ? result.device.name
                : 'Unknown Device'),
            subtitle: Text(result.device.id.id),
            trailing: Text('${result.rssi} dBm'),
onTap: () async {
  final device = result.device;

  try {
    await device.connect();
    debugPrint('✅ Connected to ${device.name}');

    List<BluetoothService> services = await device.discoverServices();

    for (var service in services) {
      for (var characteristic in service.characteristics) {
        // Find one that supports write and notify
        if (characteristic.properties.write && characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);

          // Go to ConnectedScreen and pass device + characteristic
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConnectedScreen(
                  device: device,
                  characteristic: characteristic,
                ),
              ),
            );
          }

          return;
        }
      }
    }

    debugPrint('❌ No suitable characteristic found');
  } catch (e) {
    debugPrint('❌ Error: $e');
  }
},


          );
        },
      ),
    );
  }
}
