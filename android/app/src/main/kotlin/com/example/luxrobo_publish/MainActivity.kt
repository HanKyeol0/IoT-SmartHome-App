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
//import com.example.luxrobo.databinding.ActivityMainBinding
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
//import io.reactivex.android.schedulers.AndroidSchedulers
//import io.reactivex.disposables.Disposable
//import io.reactivex.subjects.PublishSubject
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "luxrobo/ble"
    //private lateinit var binding: ActivityMainBinding

    private lateinit var bluetoothAdapter: BluetoothAdapter
    //private val isScanning: Boolean get() = scanDisposable != null
    //private var scanDisposable: Disposable? = null
    private lateinit var advertiser: BluetoothLeAdvertiser
    private var isAdvertiser = false
    private var imei = "3962"
    //private val resultsAdapter = ScanResultsAdapter()
    private var scanData = byteArrayOf()
    private var keyCodeString = StringBuilder()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { 
            call, result ->
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
                else -> result.notImplemented()
            }       
    }
        }
    

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //binding = ActivityMainBinding.inflate(layoutInflater)
        //setContentView(binding.root)
        //configureResultList()
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

    /*private fun configureResultList() {
        with(binding.scanResults) {
            setHasFixedSize(true)
            itemAnimator = null
            adapter = resultsAdapter
        }
    }*/
/* 
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        Log.d("steave", "keyCode $keyCode")
        when (keyCode) {
            in 7..16 -> keyCodeString.append(keyCode - 7)
            66 -> { // Enter
                if (keyCodeString.length == 15) {
                    stopAdvertising()
                    imei = keyCodeString.toString()
                    binding.scanMsg.text = "scan = $keyCodeString"
                    keyCodeString.clear()
                    startAdvertising()
                } else {
                    keyCodeString.clear()
                }
            }
        }
        return super.onKeyDown(keyCode, event)
    }*/

    @RequiresApi(Build.VERSION_CODES.O)
    @SuppressLint("MissingPermission")
    private fun startAdvertising(data: String) {
        bluetoothAdapter.startDiscovery()

        val byteArray = data.toByteArray(Charsets.UTF_8)

        val customData = byteArrayOf(0x43, 0x00, 0x99.toByte(), 0x99.toByte(),
            0x99.toByte(), 0x99.toByte(), 0x99.toByte(), 0x99.toByte(), 0x41, 0x00,
            0xB2.toByte(), 0x01, 0x05, 0x00, 0x50, 0x50, 0x00, 0x01, 0x00, 0xAF.toByte()
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

    private fun bellAdvertising(data1: String, data2: String) {
        bluetoothAdapter.startDiscovery()

        val byteArray = data1.toByteArray(Charsets.UTF_8) + data2.toByteArray(Charsets.UTF_8)

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
                Log.e("steave", "onStartFailure: $errorCode")
                isAdvertiser = false
            }
        }

        advertiser.startAdvertising(settingsBuilder.build(), dataBuilder.build(), advertiseCallback)
    }
/*
    private fun gateAccessAdvertising() {
        bluetoothAdapter.startDiscovery()

        AdvertiseData.Builder dataBuilder = new AdvertiseData.Builder();
        AdvertiseSettings.Builder settingsBuilder = new AdvertiseSettings.Builder();

        ParcelUuid temp = new ParcelUuid(UUID.fromString("44002104B00000044300B1410A4F504100010000"));

        dataBuilder.addServiceUuid(temp)

        settingsBuilder.setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_POWER);
        settingsBuilder.setConnectable(false);

        AdvertiseData ad = dataBuilder.build();

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

        bluetoothLeAdvertiser.startAdvertising(settingsBuilder.build(), ad, null, advertiseCallback);
    }
*/
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
