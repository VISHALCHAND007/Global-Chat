import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeCodeScreen extends StatefulWidget {
  static final routeName = "/native-code";

  const NativeCodeScreen({super.key});

  @override
  State<NativeCodeScreen> createState() => _NativeCodeScreenState();
}

class _NativeCodeScreenState extends State<NativeCodeScreen> {
  int? _batteryLevel;

  void getBatteryLevel() async {
    try {
      final channel = MethodChannel("com.global.chat/flutter");
      final batteryLevel = await channel.invokeMethod("getBatteryLevel");

      setState(() {
        _batteryLevel = batteryLevel;
      });
    } catch (error) {
      if (kDebugMode) print(error);
      setState(() {
        _batteryLevel = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBatteryLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Native device code")),
      body: Center(child: Text("Battery level:: $_batteryLevel")),
    );
  }
}
