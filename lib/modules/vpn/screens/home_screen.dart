import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import '../providers/vpn_providers.dart';
import '../../../core/routing/app_router.dart';
import 'dart:ui';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getStageText(VPNStage stage, bool isAutoConnecting) {
    if (isAutoConnecting && stage == VPNStage.disconnected) {
      return 'Searching for best server...';
    }
    switch (stage) {
      case VPNStage.connected:
        return 'Connected';
      case VPNStage.disconnected:
        return 'Disconnected';
      case VPNStage.connecting:
      case VPNStage.wait_connection:
      case VPNStage.tcp_connect:
      case VPNStage.udp_connect:
        return 'Connecting...';
      case VPNStage.authenticating:
      case VPNStage.get_config:
      case VPNStage.assign_ip:
        return 'Authenticating...';
      default:
        return 'Disconnected';
    }
  }

  Color _getStageColor(VPNStage stage, bool isAutoConnecting) {
    if (isAutoConnecting) return Colors.orange;
    switch (stage) {
      case VPNStage.connected:
        return Colors.greenAccent;
      case VPNStage.disconnected:
        return Colors.grey;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnState = ref.watch(vpnProvider);
    final vpnNotifier = ref.read(vpnProvider.notifier);

    final isConnected = vpnState.vpnStage == VPNStage.connected;
    final isConnecting =
        vpnState.isAutoConnecting ||
        (vpnState.vpnStage != VPNStage.disconnected &&
            vpnState.vpnStage != VPNStage.connected);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Gate VPN',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.serverList);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status Text
                Text(
                  vpnState.selectedServer != null
                      ? '${vpnState.selectedServer!.flagEmoji} ${vpnState.selectedServer!.countryLong} (${vpnState.selectedServer!.ping} ms)'
                      : 'Select a Server',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _getStageText(vpnState.vpnStage, vpnState.isAutoConnecting),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _getStageColor(
                      vpnState.vpnStage,
                      vpnState.isAutoConnecting,
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Main Connection Button
                GestureDetector(
                  onTap: () {
                    if (vpnState.selectedServer == null) {
                      Navigator.pushNamed(context, AppRouter.serverList);
                    } else {
                      vpnNotifier.toggleConnection();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isConnected
                            ? [Colors.redAccent, Colors.deepOrange]
                            : isConnecting
                            ? [Colors.orange, Colors.deepOrangeAccent]
                            : [Colors.blueAccent, Colors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isConnected
                                      ? Colors.redAccent
                                      : isConnecting
                                      ? Colors.orange
                                      : Colors.blueAccent)
                                  .withValues(alpha: 0.6),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: isConnecting
                          ? const SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 4,
                              ),
                            )
                          : Icon(
                              isConnected
                                  ? Icons.stop_rounded
                                  : Icons.power_settings_new_rounded,
                              size: 70,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  isConnecting
                      ? 'Connecting to secure network...'
                      : isConnected
                      ? 'Tap to Disconnect'
                      : vpnState.selectedServer == null
                      ? 'Tap to Select Server'
                      : 'Tap to Connect',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const SizedBox(height: 60),

                // Quick Connect Button
                if (!isConnected && !isConnecting)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: ElevatedButton.icon(
                        onPressed: () => vpnNotifier.autoConnect(),
                        icon: const Icon(Icons.flash_on, color: Colors.amber),
                        label: const Text(
                          'Quick Connect',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
