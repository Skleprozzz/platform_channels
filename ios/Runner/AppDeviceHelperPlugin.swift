//
//  AppDeviceHelperPlugin.swift
//  Runner
//
//  Created by Dwi Randy Herdinanto on 31/01/23.
//

import Foundation
import Flutter

public class AppDeviceHelperPlugin: NSObject, AppDeviceHelper {
    func getAppInfo() throws -> AppInfo {
        let appID: String = Bundle.main.bundleIdentifier ?? ""
        let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return AppInfo(appID: appID, appVersion: appVersion)
    }
    
    func getDeviceInfo() throws -> DeviceInfo {
        let deviceName: String = UIDevice.current.name
        let osVersion: String = UIDevice.current.systemVersion
        return DeviceInfo(deviceName: deviceName, osVersion: osVersion)
    }
    
    func getBatteryLevel() throws -> Int32 {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        return Int32(device.batteryLevel * 100)
    }
    
    public static func register(messenger: FlutterBinaryMessenger) {
        let api: AppDeviceHelper & NSObjectProtocol = AppDeviceHelperPlugin()
        AppDeviceHelperSetup.setUp(binaryMessenger: messenger, api: api)
    }
}
