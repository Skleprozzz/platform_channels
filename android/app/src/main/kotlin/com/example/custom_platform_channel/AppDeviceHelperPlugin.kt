package com.example.custom_platform_channel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build


class AppDeviceHelperPlugin(var context: Context) : PigeonAppDeviceHelper.AppDeviceHelper {


    override fun getAppInfo(): PigeonAppDeviceHelper.AppInfo {
        val appID = BuildConfig.APPLICATION_ID
        val appVersion = BuildConfig.VERSION_CODE
        return PigeonAppDeviceHelper.AppInfo.Builder().setAppID(appID).setAppVersion(appVersion.toString()).build()
    }

    override fun getDeviceInfo(): PigeonAppDeviceHelper.DeviceInfo {
        val deviceName = Build.MODEL
        val os = Build.VERSION.RELEASE
        return PigeonAppDeviceHelper.DeviceInfo.Builder().setDeviceName(deviceName).setOsVersion(os).build()
    }

    override fun getBatteryLevel(): Long {
        val batteryLevel: Int
        val intent = ContextWrapper(context).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)

        return batteryLevel.toLong()
    }

}