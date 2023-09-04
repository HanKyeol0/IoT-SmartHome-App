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
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.os.Handler
import android.os.Looper
import android.util.Base64

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

        if (!bluetoothAdapter.isEnabled) {
            Log.e("steave", "Bluetooth is not enabled")
            return
        }

        bluetoothAdapter.startDiscovery()

        //val dataByte = hexStringToByteArray(data1) C98A6B189955

        val uniqueCode = byteArrayOf(0x46.toByte(), 0xCF.toByte(), 0x82.toByte(), 0x6A.toByte(),
            0x1E.toByte(), 0xD0.toByte(), 0x65.toByte())

        val encodingData = Base64.decode("XQMa", Base64.DEFAULT)

        val customData = uniqueCode + encodingData

        val dataBuilder = AdvertiseData.Builder().apply {
            setIncludeDeviceName(true)
            //.addManufacturerData(0x4C55, customData)
            addServiceUuid(ParcelUuid.fromString("46CF826A1ED065"))
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

fun calculateCRC8(data: ByteArray): Byte {
    var crc: Byte = 0
    for (byte in data) {
        var inbyte = byte.toInt()
        for (i in 0 until 8) {
            val mix = (crc.toInt() xor inbyte) and 0x01
            crc = (crc.toInt() ushr 1).toByte()
            if (mix != 0) {
                crc = (crc.toInt() xor 0x8C).toByte()
            }
            inbyte = inbyte ushr 1
        }
    }
    return crc
}

fun calculateCRC16BUYPASS(data: ByteArray): ByteArray {
    var crc = 0x0000 // Initial value
    val polynomial = 0x8005 // Polynomial value

    for (byte in data) {
        var b = byte.toInt() and 0xFF // Ensure the byte value is between 0 and 255
        for (i in 0 until 8) {
            val bit = ((crc and 0x8000) != 0) xor ((b and 0x80) != 0)
            crc = crc shl 1
            if (bit) {
                crc = crc xor polynomial
            }
            b = b shl 1
        }
    }

    // Truncate to 16 bits
    crc = crc and 0xFFFF

    // Convert the 16-bit integer to a ByteArray
    return byteArrayOf(
        (crc shr 8 and 0xFF).toByte(),
        (crc and 0xFF).toByte()
    )
}

private fun bellAdvertising(data1: String, data2: String) {

    advertiser.stopAdvertising(advertiseCallback)
    bluetoothAdapter.cancelDiscovery()
    isAdvertiser = false

    Log.d("steave", "bellAdvertising function called at here: ${System.currentTimeMillis()}")

    if (!bluetoothAdapter.isEnabled) {
        Log.e("steave", "Bluetooth is not enabled")
        return
    }

    val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    val bluetoothAdapter = bluetoothManager.adapter
    val bluetoothLeAdvertiser = bluetoothAdapter?.bluetoothLeAdvertiser

    val data1Bytes = hexStringToByteArray(data1)
    val data2Bytes = hexStringToByteArray(data2)
    Log.d("steave", "data1Bytes: ${data1Bytes.joinToString(", ") { it.toString() }}")
    Log.d("steave", "data2Bytes: ${data2Bytes.joinToString(", ") { it.toString() }}")

    val uuidToMajor = byteArrayOf(0x44.toByte()) + data1Bytes + data2Bytes + byteArrayOf(0x4F.toByte(), 0x50.toByte(), 0x41.toByte(), 0x00.toByte(), 0xFF.toByte())

    val crcValue = calculateCRC16BUYPASS(uuidToMajor)

    val bellData = byteArrayOf(0x02.toByte(), 0x15.toByte()) + uuidToMajor + crcValue + byteArrayOf(0xC3.toByte())

    val advertiseSettings = AdvertiseSettings.Builder()
    .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_BALANCED)
    .setConnectable(true)
    .setTimeout(0)
    .build()

    val advertiseData = AdvertiseData.Builder()
        .setIncludeDeviceName(false)
        .addManufacturerData(0x004C, bellData)
        .build()

    bluetoothLeAdvertiser?.startAdvertising(advertiseSettings, advertiseData, callback)
}

val callback = object : AdvertiseCallback() {
    override fun onStartSuccess(settingsInEffect: AdvertiseSettings?) {
        super.onStartSuccess(settingsInEffect)
        println("Advertise Successful")
    }

    override fun onStartFailure(errorCode: Int) {
        super.onStartFailure(errorCode)
        println("Advertise Failed: Error Code: $errorCode")
    }
}

private fun parkingAdvertising(data1: String, data2: String) {

    //val data1Bytes = hexStringToByteArray(data1)
    //val data2Bytes = hexStringToByteArray(data2)

    Log.d("steave", "parkingAdvertising function called at here: ${System.currentTimeMillis()}")

    val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    val bluetoothAdapter = bluetoothManager.adapter
    val bluetoothLeAdvertiser = bluetoothAdapter?.bluetoothLeAdvertiser

    val customData = byteArrayOf(
        0x02, 0x15, 0x44.toByte(), 
        0x00, 0x21, 0x04, 0xB0.toByte(), 
        0x00, 0x00, 0x04, 0x43, 0x00, 0xB1.toByte(), 
        0x41, 0x0A.toByte(), 0x4F.toByte(), 0x50, 0x41, 
        0x00, 0x01, 0x00, 0x00, 0xC3.toByte()
        )

    val advertiseSettings = AdvertiseSettings.Builder()
    .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_BALANCED)
    .setConnectable(true)
    .build()

    val advertiseData = AdvertiseData.Builder()
        .setIncludeDeviceName(false)
        .addManufacturerData(0x004C, customData)
        .build()

    //val scanResponse = AdvertiseData.Builder()
    //    .setIncludeDeviceName(false)
    //    .setIncludeTxPowerLevel(false)
    //    .build()

    bluetoothLeAdvertiser?.startAdvertising(advertiseSettings, advertiseData, callback) //scanResponse, 
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
        Log.d("steave", "stopAdvertising function called at here: ${System.currentTimeMillis()}")

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
