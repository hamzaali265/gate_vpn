import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'vpn_state.dart';
import '../models/vpn_server.dart';
import '../repositories/vpn_repository.dart';
import '../../../core/network/api_service.dart';
import '../../../core/services/notification_service.dart';

class VpnNotifier extends Notifier<VpnState> {
  late final ApiService _apiService;
  late final VpnRepository _vpnRepository;

  int _autoConnectIndex = 0;
  Timer? _autoConnectTimer;

  @override
  VpnState build() {
    _apiService =
        ApiService(); // Typically passed via DI, but instantiating here for simplicity
    _vpnRepository = VpnRepository();

    _initVpnService();
    Future.microtask(() => fetchServers());

    return const VpnState();
  }

  void _initVpnService() {
    _vpnRepository.initialize();

    _vpnRepository.onVpnStatusChanged.listen((status) {
      if (kDebugMode) {
        print(
          "VPN STATUS: ${status.duration} ${status.byteIn} ${status.byteOut}",
        );
      }
      if (state.vpnStage == VPNStage.connected) {
        NotificationService().showVpnNotification(
          'Gate VPN Connected',
          'Duration: ${status.duration} | \u2193 ${status.byteIn} | \u2191 ${status.byteOut}',
          connected: true,
        );
      }
    });

    _vpnRepository.onVpnStageChanged.listen((stage) {
      bool isAutoConnecting = state.isAutoConnecting;

      if (isAutoConnecting) {
        if (stage == VPNStage.connected) {
          isAutoConnecting = false;
          _autoConnectTimer?.cancel();
        } else if (stage == VPNStage.disconnected) {
          _tryNextServer();
        }
      }

      if (stage == VPNStage.connected) {
        NotificationService().showVpnNotification(
          'Gate VPN Connected',
          'Connected securely.',
          connected: true,
        );
      } else if (stage == VPNStage.disconnected) {
        NotificationService().cancelNotification();
      } else {
        NotificationService().showVpnNotification(
          'Gate VPN',
          'Status: \${stage.name}',
          connected: false,
        );
      }

      state = state.copyWith(
        vpnStage: stage,
        isAutoConnecting: isAutoConnecting,
      );
    });
  }

  Future<void> fetchServers({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true);
    try {
      final servers = await _apiService.fetchVpnServers(
        forceRefresh: forceRefresh,
      );

      // Select best server if none selected
      VpnServer? selected = state.selectedServer;
      if (servers.isNotEmpty && selected == null) {
        selected = servers.first;
      }

      state = state.copyWith(
        servers: servers,
        selectedServer: selected,
        isLoading: false,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Failed to fetch servers: $e");
      }
      state = state.copyWith(isLoading: false);
    }
  }

  void selectServer(VpnServer server) {
    state = state.copyWith(selectedServer: server);
    if (state.vpnStage == VPNStage.connected ||
        state.vpnStage == VPNStage.connecting) {
      disconnect();
    }
  }

  Future<void> connect() async {
    cancelAutoConnect();
    if (state.selectedServer == null) {
      if (state.servers.isNotEmpty) {
        state = state.copyWith(selectedServer: state.servers.first);
      } else {
        return; // No servers available
      }
    }
    await _vpnRepository.connect(state.selectedServer!);
  }

  Future<void> disconnect() async {
    cancelAutoConnect();
    await _vpnRepository.disconnect();
  }

  void toggleConnection() {
    if (state.vpnStage == VPNStage.connected ||
        state.vpnStage == VPNStage.connecting) {
      disconnect();
    } else {
      connect();
    }
  }

  void autoConnect() {
    if (state.servers.isEmpty) return;
    state = state.copyWith(isAutoConnecting: true);
    _autoConnectIndex = -1;
    _tryNextServer();
  }

  void cancelAutoConnect() {
    state = state.copyWith(isAutoConnecting: false);
    _autoConnectTimer?.cancel();
  }

  void _tryNextServer() {
    _autoConnectTimer?.cancel();
    if (!state.isAutoConnecting || state.servers.isEmpty) return;

    _autoConnectIndex++;
    if (_autoConnectIndex >= state.servers.length) {
      state = state.copyWith(isAutoConnecting: false);
      return;
    }

    state = state.copyWith(selectedServer: state.servers[_autoConnectIndex]);
    _vpnRepository.connect(state.selectedServer!);

    _autoConnectTimer = Timer(const Duration(seconds: 10), () {
      if (state.isAutoConnecting && state.vpnStage != VPNStage.connected) {
        _vpnRepository
            .disconnect(); // Will trigger onVpnStageChanged to try next
      }
    });
  }
}
