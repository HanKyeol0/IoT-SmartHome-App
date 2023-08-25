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
import android.os.ParcelUuid
import java.nio.ByteBuffer

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
                "gateAdvertising" -> {
                    val passedData = call.argument<String?>("data")
                    if (passedData != null) {
                        gateAdvertising(passedData)
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
                "parkingAdvertising" -> {
                val data1 = call.argument<String?>("data1")
                val data2 = call.argument<String?>("data2")
                
                    if (data1 != null && data2 != null) {
                        parkingAdvertising(data1, data2)
                        result.success(null)
                    } else {
                        result.error("NO_DATA", "Data1 or Data2 missing", null)
                    }
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
    private fun gateAdvertising(data1: String) {
        Log.d("steave", "gateAdvertising function called at here: ${System.currentTimeMillis()}")

        if(bluetoothAdapter == null) {
            Log.e("steave", "Bluetooth Adapter is null")
            return
        }

        if (!bluetoothAdapter.isEnabled) {
            Log.e("steave", "Bluetooth is not enabled")
            return
        }

        bluetoothAdapter.startDiscovery()

        val dataByte = hexStringToByteArray(data1)

        val customData = byteArrayOf(0x43, 0x00, 0x11.toByte(), 0x99.toByte(),
            0x99.toByte(), 0x99.toByte(), 0x99.toByte(), 0x99.toByte(), 0x41, 0x00,
            0xB2.toByte(), 0x01, 0x05, 0x00, 0x50, 0x50, 0x00, 0x01, 0x00, 0xAC.toByte()
        )

        val dataBuilder = AdvertiseData.Builder().apply {
            setIncludeDeviceName(false)
            addManufacturerData(0x4C55, customData)
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

private fun hexStringToByteArray(s: String): ByteArray {
    val len = s.length
    val data = ByteArray(len / 2)
    var i = 0
    while (i < len) {
        data[i / 2] = ((Character.digit(s[i], 16) shl 4) + Character.digit(s[i + 1], 16)).toByte()
        i += 2
    }
    return data
}

private fun bellAdvertising(data1: String, data2: String) {
    Log.d("steave", "bellAdvertising function called at here: ${System.currentTimeMillis()}")

    if(bluetoothAdapter == null) {
        Log.e("steave", "Bluetooth Adapter is null")
        return
    }

    if (!bluetoothAdapter.isEnabled) {
        Log.e("steave", "Bluetooth is not enabled")
        return
    }

    bluetoothAdapter.startDiscovery()

    val data1Bytes = hexStringToByteArray(data1)
    val data2Bytes = hexStringToByteArray(data2)

    val byteArray = byteArrayOf(0x44) + data1Bytes + data2Bytes + byteArrayOf(0x4F, 0x50, 0x41, 0x00, 0xFF.toByte(), 0x00, 0x3B)

    val dataBuilder = AdvertiseData.Builder().apply {
        setIncludeDeviceName(false)
        addManufacturerData(0x4C55, byteArray)
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
/*
private fun parkingAdvertising(data1: String, data2: String) {
    Log.d("steave", "parkingAdvertising function called at here: ${System.currentTimeMillis()}")

    if(bluetoothAdapter == null) {
        Log.e("steave", "Bluetooth Adapter is null")
        return
    }

    if (!bluetoothAdapter.isEnabled) {
        Log.e("steave", "Bluetooth is not enabled")
        return
    }

    bluetoothAdapter.startDiscovery()

    val data1Bytes = hexStringToByteArray(data1)
    val data2Bytes = hexStringToByteArray(data2)

    val byteArray = byteArrayOf(0x44) + data1Bytes + data2Bytes + byteArrayOf(0x4F, 0x50, 0x41, 0x00, 0x01, 0x00, 0x3B)

    val dataBuilder = AdvertiseData.Builder().apply {
        setIncludeDeviceName(false)
        addManufacturerData(0x4C55, byteArray)
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
*/
private fun parkingAdvertising(data1: String, data2: String) {
    Log.d("steave", "parkingAdvertising function called at here: ${System.currentTimeMillis()}")

    if(bluetoothAdapter == null) {
        Log.e("steave", "Bluetooth Adapter is null")
        return
    }

    if (!bluetoothAdapter.isEnabled) {
        Log.e("steave", "Bluetooth is not enabled")
        return
    }

    bluetoothAdapter.startDiscovery()

    val data1Bytes = hexStringToByteArray(data1)
    val data2Bytes = hexStringToByteArray(data2)

    val byteArray = byteArrayOf(0x44) + data1Bytes + data2Bytes + byteArrayOf(0x4F, 0x50, 0x41, 0x00, 0x01, 0x00, 0x3B)

    if (byteArray.size < 16) {
        Log.e("steave", "byteArray length should be at least 16 bytes for UUID")
        return
    }

    val byteBuffer = ByteBuffer.wrap(byteArray)
    val high = byteBuffer.long
    val low = byteBuffer.long
    val customUuid = UUID(high, low)

    val parcelUuid = ParcelUuid(customUuid)

    val dataBuilder = AdvertiseData.Builder().apply {
        setIncludeDeviceName(false)
        addManufacturerData(0x4C00)
        addServiceUuid("4446CF826A1ED0654300B1410B4F504100013B") //parcelUuid
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
