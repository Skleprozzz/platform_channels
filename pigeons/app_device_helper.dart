import 'package:pigeon/pigeon.dart';

class AppInfo {
  final String appID;
  final String appVersion;

  AppInfo(this.appID, this.appVersion);
}

class DeviceInfo {
  final String deviceName;
  final String osVersion;

  DeviceInfo(this.deviceName, this.osVersion);
}

@HostApi()
abstract class AppDeviceHelper {
  AppInfo getAppInfo();

  DeviceInfo getDeviceInfo();

  int getBatteryLevel();
}
