<div align="center">
  <img src="assets/icon.png" width="150" alt="Gate VPN Logo"/>
  <h1>Gate VPN 🛡️</h1>
  <p><strong>A modern, fast, and secure Virtual Private Network (VPN) client for Android</strong></p>
  
  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/OpenVPN-EA7E20?style=for-the-badge&logo=openvpn&logoColor=white" alt="OpenVPN" />
    <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
  </p>
</div>

---

Gate VPN seamlessly connects you to hundreds of free, open-source VPN servers worldwide using the powerful [VPNGate](https://www.vpngate.net/) API. Designed with a focus on performance, security, and user experience.

<br/>

## ✨ Key Features

| Feature | Description |
| :--- | :--- |
| ⚡ **One-Tap Connect** | Instantly connect to the most optimal server with a single tap. No complex configurations. |
| 🌍 **Global Server List** | Browse, refresh, and sort hundreds of available servers from all over the world. |
| 📊 **Real-time Metrics** | View live connection duration, server ping (ms), and active download/upload speeds. |
| 🚀 **Smart Caching** | Utilizes a 6-hour stale-while-revalidate strategy. The server list loads instantly without blocking the UI. |
| 🔔 **Background Tracking** | Displays a persistent, native Android notification tracking connection duration and data usage. |
| 🔄 **Auto-Reconnect** | Automatically finds and connects to the next best server if your current connection drops. |

<br/>


## 🛠️ Tech Stack & Architecture

Gate VPN strictly follows a **feature-based MVVM architecture** designed for high scalability and separation of concerns.

- **UI Framework:** Flutter (Dart)
- **State Management:** [Riverpod](https://pub.dev/packages/flutter_riverpod)
- **Native Integration:** [openvpn_flutter](https://pub.dev/packages/openvpn_flutter)
- **Caching Layer:** [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)
- **Data Parsing:** Parsed in background isolates using `compute()` to ensure smooth 60fps UI performance.

```text
lib/
 ├── core/
 │    ├── network/          # API Services & Caching logic
 │    ├── routing/          # Centralized AppRouter
 │    └── services/         # Native Notification Services
 └── modules/
      └── vpn/
           ├── logic/       # VpnNotifier & VpnState (Riverpod)
           ├── models/      # Data models (VpnServer)
           ├── providers/   # Global provider definitions
           ├── repositories/# Native OpenVPN integration layer
           └── screens/     # UI components (HomeScreen, ServerListScreen)
```

<br/>

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (v3.10+)
* Android Studio / Android SDK

### Installation

1. **Clone the repository:**
   ```bash
   git clone git@github.com:hamzaali265/gate_vpn.git
   cd gate_vpn
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

> ⚠️ **Note:** OpenVPN on Android requires the `VpnService` permission. The app will automatically prompt the user to grant this permission upon their first connection attempt.

<br/>

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! 
If you plan on making major changes, please open an issue first to discuss what you would like to change.

<br/>

## 📄 License

This project is licensed under the [MIT License](https://choosealicense.com/licenses/mit/).
