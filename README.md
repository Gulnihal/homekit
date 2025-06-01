# 🏠 HomeKit ESP32 Provisioning & Control App

This Flutter-based mobile application allows users to onboard ESP32-based IoT devices to a Wi-Fi network, control them, and monitor their real-time sensor data. It features a Node.js backend and ESP32 firmware designed for seamless integration.

---

## 🚀 Features

- 📲 Provision ESP32 devices onto any Wi-Fi network via Flutter UI
- 📡 SoftAP (ESP32 hotspot) → target Wi-Fi transition support
- 🧠 Node.js backend handles device registration and validation
- 🌡️ Live readings from temperature, humidity, pulse, and gas sensors
- 🔔 Built-in buzzer alerts and WS2812 RGB LED status indicators
- ✅ Flutter UI for device setup, success/failure feedback
- 🔒 Token-based user authentication system

---

## 📦 Tech Stack

| Layer        | Technology |
|--------------|------------|
| Mobile App   | Flutter 3.x |
| Backend      | Node.js (Express) |
| IoT Device   | ESP32 (WROOM-32U), DHT11, MQ2, WS2812 |
| Database     | MongoDB |
| Communication| HTTP (RESTful, JSON + x-www-form-urlencoded) |

---

## 📲 Flutter Screens

- **AddDevice:** Device Wi-Fi setup screen
- **DeviceList:** List of registered devices
- **DeviceDetail:** Real-time monitoring & control
- **Login/Register:** User authentication

---

## 🔧 Setup Instructions

### 1. Flutter App

```bash
git clone https://github.com/yourusername/homekit_app.git
cd homekit_app
flutter pub get
flutter run
```

### 2. Node.js Backend

```bash
cd homekit_server
npm install
npm start
```

### 3. ESP32 Device

- Load the provided code via Arduino IDE or PlatformIO
- On startup, ESP32 opens a SoftAP (e.g., ESP32_Setup)
- The Flutter app sends Wi-Fi credentials to the ESP32

---

## 🧪 Sensors & Modules Used
- DHT11 — Temperature & Humidity
- MQ2 — Gas (LPG, smoke)
- WS2812 — RGB LED Ring
- IR Pulse Sensor — Heartbeat monitor
- Buzzer — Audio alarm

---

## 📂 Project Structure (Simplified)

homekit_app/
├── lib/
│   ├── pages/
│   │   ├── add_device.dart
│   │   ├── device_list.dart
│   │   ├── device_detail.dart
│   └── common/widgets/
│       ├── custom_button.dart
│       ├── custom_textfield.dart
├── backend/
│   ├── routes/user.js
│   ├── models/device.js
│   └── server.js
├── esp32/
│   └── main.ino
