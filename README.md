# Gate VPN 🛡️

A modern, fast, and secure Virtual Private Network (VPN) client for Android, built with **Flutter** and powered by **OpenVPN**. Gate VPN seamlessly connects you to hundreds of free, open-source VPN servers worldwide via the [VPNGate](https://www.vpngate.net/) API.

## Features ✨
* **One-Tap Connect**: Instantly connect to the optimal server with a single tap.
* **Global Server List**: Browse, refresh, and sort hundreds of available servers globally.
* **Real-time Status**: View live connection duration, Ping (ms), and download/upload speeds.
* **Smart Caching**: Implements `flutter_cache_manager` with a 6-hour stale-while-revalidate strategy for lightning-fast server list loading without blocking the UI thread.
* **Robust State Management**: Powered by Riverpod for highly scalable and reactive MVVM architecture.
* **Background Notifications**: Displays a persistent native Android notification tracking connection duration and byte transfers.
* **Automatic Reconnection**: Automatically finds and connects to the next best server if the current one drops.

## Screenshots 📸
*(Add your screenshots here!)*

| Home Screen | Server List | Connected State |
| :---: | :---: | :---: |
| <img src="assets/screenshot_home.png" width="250"/> | <img src="assets/screenshot_servers.png" width="250"/> | <img src="assets/screenshot_connected.png" width="250"/> |

## Tech Stack 🛠️
- **Framework**: Flutter (Dart)
- **Architecture**: MVVM with Modular Structure
- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- **Native Integration**: [openvpn_flutter](https://pub.dev/packages/openvpn_flutter)
- **Networking & Parsing**: `http`, `csv` (Parsed in background isolates using `compute()`)
- **Caching**: [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)

## Getting Started 🚀

### Prerequisites
* Flutter SDK (v3.10+)
* Android Studio / Android SDK

### Installation
1. Clone the repository:
   ```bash
   git clone git@github.com:hamzaali265/gate_vpn.git
   ```
2. Navigate to the directory:
   ```bash
   cd gate_vpn
   ```
3. Get the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

> **Note:** OpenVPN on Android requires the `VpnService` permission. The app will prompt the user to grant this permission upon the first connection attempt.

## Architecture 🏗️
The project strictly follows a **feature-based MVVM architecture** for maximum scalability:
```text
lib/
 ├── core/
 │    ├── network/          # API Service & Caching logic
 │    ├── routing/          # AppRouter
 │    └── services/         # NotificationServices
 └── modules/
      └── vpn/
           ├── logic/       # VpnNotifier & VpnState (Riverpod)
           ├── models/      # VpnServer data model
           ├── providers/   # Global provider definitions
           ├── repositories/# Native OpenVPN integration
           └── screens/     # HomeScreen, ServerListScreen, SplashScreen
```

## Contributing 🤝
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License 📄
[MIT](https://choosealicense.com/licenses/mit/)
