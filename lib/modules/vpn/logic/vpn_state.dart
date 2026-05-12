import 'package:openvpn_flutter/openvpn_flutter.dart';
import '../models/vpn_server.dart';

class VpnState {
  final List<VpnServer> servers;
  final bool isLoading;
  final VpnServer? selectedServer;
  final VPNStage vpnStage;
  final bool isAutoConnecting;

  const VpnState({
    this.servers = const [],
    this.isLoading = false,
    this.selectedServer,
    this.vpnStage = VPNStage.disconnected,
    this.isAutoConnecting = false,
  });

  VpnState copyWith({
    List<VpnServer>? servers,
    bool? isLoading,
    VpnServer? selectedServer,
    VPNStage? vpnStage,
    bool? isAutoConnecting,
  }) {
    return VpnState(
      servers: servers ?? this.servers,
      isLoading: isLoading ?? this.isLoading,
      selectedServer: selectedServer ?? this.selectedServer,
      vpnStage: vpnStage ?? this.vpnStage,
      isAutoConnecting: isAutoConnecting ?? this.isAutoConnecting,
    );
  }
}
