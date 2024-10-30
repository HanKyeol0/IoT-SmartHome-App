# Iot SmartHome App

IoT Smart Home Application project.
The app was made by Flutter,
except for BLE(Bluetooth Low Energy) data advertising functions,
which was developed from Native part(AOS, iOS).

(The entire code is at "develop" branch)

# Summary

This app was desinged to be used by certain apartments' residents.

1. Login

Users can verify themselves by entering pre-registered user info,
including apartment name, address, and user name.

2. Gate Access

Users can access gates using the app.
When you press "터치해서 현관문 출입(Automatic Access)" button while you are around the BLE module device,
the app sends BLE(Bluetooth Low Energy) data that contains the user's UUID, to the BLE module attached to a gate.
Then the server verifies the UUID and open the gate.

3. Parking Lot check

Users can save the location where they parked cars.
When you press "터치해서 주차하기(Press to park)" button,
the app sends BLE data to the nearest BLE module installed at a parking lot.
After that, you can view the car location marked on the parking lot's map.

4. Emergency Bell

You can call an administrator of apartment (such as janitors) using the app.
When you press "터치해서 비상벨 울리기(Press to call emergency bell)" button for 1 second,
the app advertises BLE data, and a BLE module that receives the data transfer it to the server.
Then the administrator can call with the user on admin site, through a CCTV.
