package com.example.custom_platform_channel

import android.content.BroadcastReceiver
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {

    companion object {
        private const val CHARGING_CHANNEL = "custom.channel_name.getChargingStatus"
        private const val BATTERY_STATUS = "custom.channel_name.getBatteryStatus"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        PigeonAppDeviceHelper.AppDeviceHelper.setup(flutterEngine.dartExecutor.binaryMessenger, AppDeviceHelperPlugin(context))
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, Companion.CHARGING_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                var receiver : BroadcastReceiver? = null
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    receiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context?, intent: Intent) {
                            var status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                            if (status == BatteryManager.BATTERY_STATUS_UNKNOWN) {
                                events.error("UNAVAILABLE", "Charging status unavailable", null);
                            } else {
                                val isCharging =
                                    status == BatteryManager.BATTERY_STATUS_CHARGING ||
                                            status == BatteryManager.BATTERY_STATUS_FULL
                                events.success(if (isCharging) "charging" else "discharging")
                            }
                        }
                    }
                    ContextWrapper(applicationContext).registerReceiver(
                        receiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                    )
                }
                override fun onCancel(arguments: Any?) {
                    ContextWrapper(applicationContext).unregisterReceiver(receiver)
                    receiver = null
                }
            }
        )
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, Companion.BATTERY_STATUS).setStreamHandler(
            object : EventChannel.StreamHandler {
                var receiver : BroadcastReceiver? = null
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    receiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context?, intent: Intent) {
                            var batteryLevel = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
                            events.success(batteryLevel)
                        }
                    }
                    ContextWrapper(applicationContext).registerReceiver(
                        receiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                    )
                }
                override fun onCancel(arguments: Any?) {
                    ContextWrapper(applicationContext).unregisterReceiver(receiver)
                    receiver = null
                }
            }
        )
    }

}
