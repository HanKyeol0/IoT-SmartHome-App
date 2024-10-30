# Iot SmartHome Mobile App

An IoT Smart Home Mobile Application project developed primarily in Flutter,
with BLE (Bluetooth Low Energy) data advertising functionality
implemented natively for Android and iOS.

The complete code is available on the "develop" branch.

# Summary

This app is designed for residents of specific apartment complexes.

1. Login

Users can verify their identity by entering pre-registered information, including the apartment name, address, and username.

2. Gate Access

Users can access gates through the app. When the "터치해서 현관문 출입 (Automatic Access)" button is pressed near a BLE module device, the app sends BLE data containing the user's UUID to the BLE module attached to the gate. The server then verifies the UUID and opens the gate.

3. Parking Lot check

Users can save the location of their parked cars. When the "터치해서 주차하기 (Press to Park)" button is pressed, the app sends BLE data to the nearest BLE module in the parking lot. Afterward, users can view the car's location on the parking lot map.

4. Emergency Bell

Users can contact apartment administrators (such as janitors) via the app. Pressing the "터치해서 비상벨 울리기 (Press to Call Emergency Bell)" button for one second activates the BLE data broadcast, which is then received by a BLE module and sent to the server. The administrator can initiate a call with the user via CCTV on the admin site.
