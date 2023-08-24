package com.example.luxrobo

import android.annotation.SuppressLint
import android.Manifest
import android.bluetooth.*
import android.bluetooth.le.*
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "luxrobo/ble"

    private lateinit var bluetoothAdapter: BluetoothAdapter
    private lateinit var advertiser: BluetoothLeAdvertiser
    private var isAdvertiser = false
    private var imei = "3962"
    private var scanData = byteArrayOf()
    private var keyCodeString = StringBuilder()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { 
            call, result ->
            Log.i("MethodChannel", "Method ${call.method} invoked")
            when(call.method) {
                "startAdvertising" -> {
                    val passedData = call.argument<String?>("data")
                    if (passedData != null) {
                        startAdvertising(passedData)
                        result.success(null)
                    } else {
                        result.error("NO_DATA", "No data passed", null)
                    }
                }
                "stopAdvertising" -> {
                    stopAdvertising()
                    result.success(null)
                }
                "bellAdvertising" -> {
                val data1 = call.argument<String?>("data1")
                val data2 = call.argument<String?>("data2")
                
                    if (data1 != null && data2 != null) {
                        bellAdvertising(data1, data2)
                        result.success(null)
                    } else {
                        result.error("NO_DATA", "Data1 or Data2 missing", null)
                    }
                }
                "bellAdvertisingTest" -> {
                    bellAdvertisingTest()
                    result.success(null)
                }
                else -> result.notImplemented()
            }       
    }
        }
    

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        permissionCheck()
        bleInit()
    }

    override fun onResume() {
        super.onResume()
    }

    private fun bleInit() {
        setBluetoothAdapter()
        turnOnBluetooth()
        advertiser = bluetoothAdapter.bluetoothLeAdvertiser
    }

    private fun permissionCheck() {
        val permissionsNeeded = mutableListOf<String>()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.BLUETOOTH_ADVERTISE
            ).forEach {
                if (ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED) {
                    permissionsNeeded.add(it)
                }
            }
        }

        arrayOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.PACKAGE_USAGE_STATS,
            Manifest.permission.ACCESS_COARSE_LOCATION
        ).forEach {
            if (ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED) {
                permissionsNeeded.add(it)
            }
        }

        if (permissionsNeeded.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, permissionsNeeded.toTypedArray(), 1000)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == 1000) {
            for ((index, permission) in permissions.withIndex()) {
                if (grantResults[index] != PackageManager.PERMISSION_GRANTED) {
                    Log.e("Permission Denied", "Permission for $permission was denied.")
                    // Handle what to do if permission is not granted. E.g., inform the user or close the app.
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    @SuppressLint("MissingPermission")
    private fun startAdvertising(data: String) {
        bluetoothAdapter.startDiscovery()

        val byteArray = data.toByteArray(Charsets.UTF_8)

        val customData = byteArrayOf(0x43, 0x00, 0x11.toByte(), 0x99.toByte(),
            0x99.toByte(), 0x99.toByte(), 0x99.toByte(), 0x99.toByte(), 0x41, 0x00,
            0xB2.toByte(), 0x01, 0x05, 0x00, 0x50, 0x50, 0x00, 0x01, 0x00, 0xAC.toByte()
        )

        val dataBuilder = AdvertiseData.Builder().apply {
            setIncludeDeviceName(false)
            addManufacturerData(0x4C54, customData)
            //addManufacturerData(0x4C55, byteArray)
        }

        val settingsBuilder = AdvertiseSettings.Builder().apply {
            setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_POWER)
            setConnectable(false)
            setTimeout(0)
        }

        val advertiseCallback = object : AdvertiseCallback() {
            override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
                super.onStartSuccess(settingsInEffect)
                Log.i("steave", "onStartSuccess: $settingsInEffect")
                isAdvertiser = true
            }

            override fun onStartFailure(errorCode: Int) {
                super.onStartFailure(errorCode)
                Log.e("steave", "onStartFailure: $errorCode")
                isAdvertiser = false
            }
        }

        advertiser.startAdvertising(settingsBuilder.build(), dataBuilder.build(), advertiseCallback)
    }

private fun bellAdvertising(data1: String, data2: String) {
    Log.d("steave", "bellAdvertising function called at: ${System.currentTimeMillis()}")

    if(bluetoothAdapter == null) {
        Log.e("steave", "Bluetooth Adapter is null")
        return
    }

    if (!bluetoothAdapter.isEnabled) {
        Log.e("steave", "Bluetooth is not enabled")
        return
    }

    bluetoothAdapter.startDiscovery()

    val byteArray = byteArrayOf(0x44.toByte()) + data1.toByteArray(Charsets.UTF_8) + data2.toByteArray(Charsets.UTF_8)

    Log.d("steave", "Advertising byteArray: ${byteArray.joinToString(", ") { it.toString() }}")

    val customData = byteArrayOf(0x43, 0x00, 0x11.toByte(), 0x99.toByte(),
        0x99.toByte(), 0x99.toByte(), 0x99.toByte(), 0x99.toByte(), 0x41, 0x00,
        0xB2.toByte(), 0x01, 0x05, 0x00, 0x50, 0x50, 0x00, 0x01, 0x00, 0xAC.toByte()
    )

    Log.d("steave", "Custom Advertising Data: ${customData.joinToString(", ") { it.toString() }}")

    val dataBuilder = AdvertiseData.Builder().apply {
        setIncludeDeviceName(false)
        addManufacturerData(0x4C54, customData)
    }

    val settingsBuilder = AdvertiseSettings.Builder().apply {
        setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_POWER)
        setConnectable(false)
        setTimeout(0)
    }

    val advertiseCallback = object : AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
            super.onStartSuccess(settingsInEffect)
            Log.i("steave", "onStartSuccess: $settingsInEffect")
            isAdvertiser = true
        }

        override fun onStartFailure(errorCode: Int) {
            super.onStartFailure(errorCode)
            Log.e("steave", "onStartFailure: $errorCode, Error description: ${getStartFailureDescription(errorCode)}")
            isAdvertiser = false
        }
    }

    advertiser.startAdvertising(settingsBuilder.build(), dataBuilder.build(), advertiseCallback)
}

private fun bellAdvertisingTest() {
    Log.d("steave", "bellAdvertising function called at: ${System.currentTimeMillis()}")

    if(bluetoothAdapter == null) {
        Log.e("steave", "Bluetooth Adapter is null")
        return
    }

    if (!bluetoothAdapter.isEnabled) {
        Log.e("steave", "Bluetooth is not enabled")
        return
    }

    bluetoothAdapter.startDiscovery()

    val customData = byteArrayOf(0x02.toByte(), 0x46.toByte(), 0xCF.toByte(), 0x82.toByte(),
        0x6A.toByte(), 0x1E.toByte(), 0xD0.toByte(), 0x65.toByte())
/*
    val customData = byteArrayOf(0x42, 0xCF.toByte(), 0x82.toByte(),
        0x6A.toByte(), 0x1E.toByte(), 0xD0.toByte(), 0x65.toByte(), 0x34, 0xB4.toByte(),
        0x72.toByte(), 0x94.toByte(), 0x76, 0x06, 0x4F, 0x50, 0x41, 0x00, 0x01, 0x00, 0xAC.toByte()
    )

    val customData = byteArrayOf(0x42, 0x00, 0x21.toByte(), 0x04.toByte(),
            0xB0.toByte(), 0x00.toByte(), 0x00.toByte(), 0x04.toByte(), 0x43, 0x00,
            0xB1.toByte(), 0x41, 0x0A, 0x4F, 0x50, 0x41, 0x00, 0x01, 0x00, 0xAC.toByte()
        )
*/
    val dataBuilder = AdvertiseData.Builder().apply {
        setIncludeDeviceName(false)
        addManufacturerData(0x5D03, customData)
    }

    val settingsBuilder = AdvertiseSettings.Builder().apply {
        setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_POWER)
        setConnectable(false)
        setTimeout(0)
    }

    val advertiseCallback = object : AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
            super.onStartSuccess(settingsInEffect)
            Log.i("steave", "onStartSuccess: $settingsInEffect")
            isAdvertiser = true
        }

        override fun onStartFailure(errorCode: Int) {
            super.onStartFailure(errorCode)
            Log.e("steave", "onStartFailure: $errorCode, Error description: ${getStartFailureDescription(errorCode)}")
            isAdvertiser = false
        }
    }

    advertiser.startAdvertising(settingsBuilder.build(), dataBuilder.build(), advertiseCallback)
}

private fun getStartFailureDescription(errorCode: Int): String {
    return when(errorCode) {
        AdvertiseCallback.ADVERTISE_FAILED_ALREADY_STARTED -> "ADVERTISE_FAILED_ALREADY_STARTED"
        AdvertiseCallback.ADVERTISE_FAILED_DATA_TOO_LARGE -> "ADVERTISE_FAILED_DATA_TOO_LARGE"
        AdvertiseCallback.ADVERTISE_FAILED_FEATURE_UNSUPPORTED -> "ADVERTISE_FAILED_FEATURE_UNSUPPORTED"
        AdvertiseCallback.ADVERTISE_FAILED_INTERNAL_ERROR -> "ADVERTISE_FAILED_INTERNAL_ERROR"
        AdvertiseCallback.ADVERTISE_FAILED_TOO_MANY_ADVERTISERS -> "ADVERTISE_FAILED_TOO_MANY_ADVERTISERS"
        else -> "UNKNOWN_ERROR"
    }
}


    private fun stopAdvertising() {
        advertiser.stopAdvertising(advertiseCallback)
        bluetoothAdapter.cancelDiscovery()
        isAdvertiser = false
    }

    private fun setBluetoothAdapter() {
        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothAdapter = bluetoothManager.adapter
    }

    private fun turnOnBluetooth() {
        if (!bluetoothAdapter.isEnabled) {
            bluetoothAdapter.enable()
        }
    }

    private val advertiseCallback = object : AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
            super.onStartSuccess(settingsInEffect)
            Log.i("steave", "onStartSuccess: $settingsInEffect")
        }

        override fun onStartFailure(errorCode: Int) {
            super.onStartFailure(errorCode)
            Log.e("steave", "onStartFailure: $errorCode")
        }
    }
}
