# **GluMon - Bluetooth Glucose Monitoring App**

🚀 _Real-time glucose monitoring and trend analysis via Bluetooth-enabled devices._

## **📌 Features**

✅ **Bluetooth Device Connection** – Scan and connect to glucose monitors.

✅ **Real-time Glucose Monitoring** – Receive live glucose readings via Bluetooth.

✅ **Data Visualization** – Track trends using interactive charts.

✅ **Automatic Data Logging** – Store glucose levels, temperature, and humidity.

✅ **Custom Alerts & Settings** – Manage glucose thresholds and notifications.

✅ **Minimal & Intuitive UI** – Clean, user-friendly design with a focus on clarity.

## **🛠️ Tech Stack**

- **Flutter (Dart)** – Cross-platform mobile development.
- **Flutter Blue Plus** – Bluetooth Low Energy (BLE) integration.
- **SQLite / Firebase** – Data storage & logging.
- **TFLite (TensorFlow Lite)** – Potential ML integration for predictive analytics.
- **FL Chart** – For glucose trend visualization.

## **🚀 Getting Started**

### **1️⃣ Prerequisites**

Ensure you have:

- Flutter SDK installed
- Android Studio / VS Code setup
- A Bluetooth-enabled glucose monitor

### **2️⃣ Clone Repository**

```bash
git clone https://github.com/jingjingyang0803/GluMon.git
cd glu_mon
```

### **3️⃣ Install Dependencies**

```bash
flutter pub get
```

### **4️⃣ Run the App**

#### **For Android:**

```bash
flutter run
```

#### **For iOS:**

```bash
cd ios && pod install && cd ..
flutter run
```

> **Note:** Ensure Bluetooth permissions are granted on your device.

---

## **🔹 Key Modules & Code Overview**

### **1️⃣ Bluetooth Connection (`BluetoothPage.dart`)**

- Scans and lists available Bluetooth devices.
- Connects to a selected glucose monitor.
- Displays connection status.

### **2️⃣ Real-time Glucose Monitoring (`MeasurePage.dart`)**

- Reads glucose levels from the connected device.
- Displays **"Measuring glucose levels..."** or **"No device connected"** messages.
- Shows a circular gauge and glucose wave animation.

### **3️⃣ Data Logging (`DatabaseService.dart`)**

- Stores glucose, temperature, and humidity readings.
- Fetches daily glucose trends for visualization.

### **4️⃣ Trend Analysis (`TrendPage.dart`)**

- Uses **FL Chart** to visualize glucose variations throughout the day.
- Provides **min, max, and average** glucose readings.

## **⚙️ Configuration**

### **🔹 Required Permissions**

#### **For Android (`AndroidManifest.xml`):**

```xml
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```

#### **For iOS (`Info.plist`):**

```xml
<key>NSBluetoothPeripheralUsageDescription</key>
<string>App requires Bluetooth to connect with glucose monitors.</string>
```

---

## **🚀 Future Enhancements**

📌 **Machine Learning (AI-based prediction for glucose trends)**

📌 **Cloud storage (Firebase integration for backup & sharing)**

📌 **Push Notifications (Glucose level alerts)**

📌 **Data Export**

📌 **Glucose Unit and Measure Period settings**

## **📄 License**

This project is **open-source** under the [MIT License](LICENSE).

## **💬 Support & Contribution**

- **Found a bug?** Create an issue.
- **Want to contribute?** Fork & submit a PR.
- **Need help?** Reach out via email or discussions.

🚀 **Happy coding & stay healthy!** 😊💙
