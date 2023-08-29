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
            .setIncludeDeviceName(true)
            //.addManufacturerData(0x4C55, customData)
            .addServiceUuid(ParcelUuid.fromString("46CF826A1ED065"))
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

    if (byteArray.size < 16) {
        Log.e("steave", "byteArray length should be at least 16 bytes for UUID")
        return
    }

    val byteBuffer = ByteBuffer.wrap(byteArray)
    val high = byteBuffer.long
    val low = byteBuffer.long
    val customUuid = UUID(high, low)

    val parcelUuid = ParcelUuid(customUuid)

    ParcelUuid pUuid = new ParcelUuid(UUID.fromString("4446CF826A1ED0654300B1410B4F504100013B"));

    val dataBuilder = AdvertiseData.Builder().apply {
        
        setIncludeDeviceName(false)
        addManufacturerData(0x4C00)
        addServiceUuid(pUuid)
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
/*
private fun parkingAdvertising(data1: String, data2: String) {

    val data1Bytes = hexStringToByteArray(data1)
    val data2Bytes = hexStringToByteArray(data2)

    Log.d("steave", "parkingAdvertising function called at here: ${System.currentTimeMillis()}")

    val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    val bluetoothAdapter = bluetoothManager.adapter
    val bluetoothLeAdvertiser = bluetoothAdapter?.bluetoothLeAdvertiser

    fun byteArrayToUUID(bytes: ByteArray): UUID {
        val bb = ByteBuffer.wrap(bytes)
        val high = bb.long
        val low = bb.long
        return UUID(high, low)
    }
    
    val customData = byteArrayOf(
        0x44, 0x00, 0x21.toByte(), 0x04.toByte(),
        0xB0.toByte(), 0x00.toByte(), 0x00.toByte(), 0x44.toByte(),
        0x30, 0x00, 0xB1.toByte(), 0x41, 0x0A, 0x4F, 0x50, 0x41
    )
    
    //val uuid = byteArrayToUUID(customData)
    //val parcelUuid = ParcelUuid(uuid)

    // UUID
    
    val uuid = UUID.fromString("44002104-B000-0044-3000-B1410A4F5041")
    val uuidBytes = ByteBuffer.wrap(ByteArray(16))
        .putLong(uuid.mostSignificantBits)
        .putLong(uuid.leastSignificantBits)
        .array()
        

    //val parcelUuid = UUID(uuidBytes)

    val manufacturerData = ByteBuffer.allocate(9)
    manufacturerData.put(byteArrayOf(0x02, 0x01, 0x06))
    manufacturerData.put(byteArrayOf(0x1A.toByte(), 0xFF.toByte()))
    manufacturerData.put(byteArrayOf(0x00, 0x4C)) // Company ID
    manufacturerData.put(byteArrayOf(0x02, 0x15)) // iBeacon type
    //manufacturerData.put(uuidBytes)               // UUID
    //manufacturerData.put(byteArrayOf(0x00, 0x01))
    //manufacturerData.put(byteArrayOf(0x02, 0x03))
    //manufacturerData.put(byteArrayOf(0xC3.toByte()))

    val advertiseSettings = AdvertiseSettings.Builder()
        .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY)
        .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_HIGH)
        .setConnectable(false)
        .build()

    val serviceData = ByteBuffer.allocate(5)
        serviceData.put(byteArrayOf(0x00, 0x01))
        serviceData.put(byteArrayOf(0x02, 0x03))
        serviceData.put(byteArrayOf(0xC3.toByte()))

    val advertiseData = AdvertiseData.Builder()
        .setIncludeDeviceName(false)
        .setIncludeTxPowerLevel(false)
        .addManufacturerData(0x004C, manufacturerData.array())
        .addServiceData(ParcelUuid.fromString("44002104-B000-0044-3000-B1410A4F5041"), serviceData.array())
        //.addServiceUuid(ParcelUuid.fromString("44002104-B000-0044-3000B-1410A4F5041"))
        //.addManufacturerData(manufacturerData2.array())
        //.addServiceUuid(parcelUuid)
        .build()

    val scanResponse = AdvertiseData.Builder()
        .setIncludeDeviceName(false)
        .setIncludeTxPowerLevel(false)
        .build()

    bluetoothLeAdvertiser?.startAdvertising(advertiseSettings, advertiseData, callback) //scanResponse, 
}
*/

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
    .setConnectable(false)
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

//----------------------------------------------------
/*
private fun parkingAdvertising(data1: String, data2: String) {

    val data1Bytes = hexStringToByteArray(data1)
    val data2Bytes = hexStringToByteArray(data2)

    val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    val bluetoothAdapter = bluetoothManager.adapter
    val bluetoothLeAdvertiser = bluetoothAdapter.bluetoothLeAdvertiser

    bluetoothLeAdvertiser?.stopAdvertising(callback)

    val manufacturerData = ByteBuffer.allocate(23)
    manufacturerData.put(0, 0x02.toByte())  // Beacon identifier
    manufacturerData.put(1, 0x15.toByte())  // Beacon type
    // 16-byte UUID
    val uuid = UUID.fromString("44002104-B000-0044-3000-B1410A4F5041")
    val uuidBytes = ByteBuffer.wrap(ByteArray(16))
        .putLong(uuid.mostSignificantBits)
        .putLong(uuid.leastSignificantBits)
        .array()
    manufacturerData.put(uuidBytes, 0, 16)
    // Major number
    manufacturerData.put(17, 0.toByte())
    manufacturerData.put(18, 1.toByte())
    // Minor number
    manufacturerData.put(19, 0.toByte())
    manufacturerData.put(20, 2.toByte())
    // Tx power
    manufacturerData.put(21, (-59).toByte())

    val advertiseSettings = AdvertiseSettings.Builder()
        .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY)
        .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_HIGH)
        .setConnectable(false)
        .build()

    val advertiseData = AdvertiseData.Builder()
        .setIncludeDeviceName(false)
        .setIncludeTxPowerLevel(false)
        .addManufacturerData(0x004C, manufacturerData.array())  // Apple's company ID is 0x004C
        .build()

    val scanResponse = AdvertiseData.Builder()
        .setIncludeDeviceName(false)
        .setIncludeTxPowerLevel(false)
        .build()

    bluetoothLeAdvertiser.startAdvertising(advertiseSettings, advertiseData, scanResponse, callback)
}
*/
//------------------------------------------------------------------------------

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
