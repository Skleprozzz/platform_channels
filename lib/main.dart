import 'dart:async';

import 'package:flutter/material.dart';
import 'package:custom_platform_channel/app_device_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppInfo appInfo = AppInfo(appID: "", appVersion: "");
  DeviceInfo deviceInfo = DeviceInfo(deviceName: "", osVersion: "");
  int batteryLevel = 0;
  AppDeviceHelper deviceHelper = AppDeviceHelper();
  String chargingStatus = 'unknown.';
  StreamSubscription? subscription;
  StreamSubscription? batterySubscription;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    deviceHelper.init();
    final appInfoRetrieved = await deviceHelper.getAppInfo();
    final deviceInfoRetrieved = await deviceHelper.getDeviceInfo();
    final batteryLevelRetrieved = await deviceHelper.getBatteryLevel();

    subscription = deviceHelper.chargingStatusStream
        .listen(_onChargingData, onError: _onChargingError);
    batterySubscription = deviceHelper.batteryValueStream
        .listen(_onBatteryData, onError: _onBatteryError);



    setState(() {
      appInfo = appInfoRetrieved;
      deviceInfo = deviceInfoRetrieved;
      batteryLevel = batteryLevelRetrieved;
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    batterySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("Platform Channel")),
        body: Center(
          child: Column(
            children: [
              const Text(
                "Platform Channel Example",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              const Text(
                "Application Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Text("App ID: ${appInfo.appID}"),
              Text("App Version: ${appInfo.appVersion}"),
              const SizedBox(height: 8),
              const Text(
                "Device Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Text("Device Name: ${deviceInfo.deviceName}"),
              Text("OS Version: ${deviceInfo.osVersion}"),
              Text("Battery Level: $batteryLevel%"),
              Text("Charging status: $chargingStatus"),
            ],
          ),
        ),
      ),
    );
  }

  void _onChargingData(Object? event) {
    setState(() {
      chargingStatus =
          "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
    });
  }

  void _onChargingError(Object error) {
    setState(() {
      chargingStatus = 'Battery status: unknown.';
    });
  }

  void _onBatteryData(Object? event) {
    setState(() {
      if (event != null && event is int) batteryLevel = event;
    });
  }

  void _onBatteryError(Object error) {
    setState(() {
      batteryLevel = 0;
    });
  }
}
