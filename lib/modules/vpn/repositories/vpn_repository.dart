import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import '../models/vpn_server.dart';

class VpnRepository {
  late OpenVPN _openVPN;
  bool _isInitialized = false;

  final _statusController = StreamController<VpnStatus>.broadcast();
  final _stageController = StreamController<VPNStage>.broadcast();

  Stream<VpnStatus> get onVpnStatusChanged => _statusController.stream;
  Stream<VPNStage> get onVpnStageChanged => _stageController.stream;

  VpnRepository() {
    _openVPN = OpenVPN(
      onVpnStatusChanged: (status) {
        if (!_statusController.isClosed) {
          _statusController.add(status!);
        }
      },
      onVpnStageChanged: (stage, rawStage) {
        if (!_stageController.isClosed) {
          _stageController.add(stage);
        }
      },
    );
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await _openVPN.initialize(
        groupIdentifier: 'group.com.example.gate_vpn',
        providerBundleIdentifier: 'com.example.gate_vpn.VPNExtension',
        localizedDescription: 'Gate VPN Connection',
      );
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print("Failed to initialize OpenVPN: \$e");
      }
    }
  }

  Future<void> connect(VpnServer server) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (Platform.isAndroid) {
      final hasPermission = await _openVPN.requestPermissionAndroid();
      if (!hasPermission) return;
    }

    try {
      final configString = utf8.decode(
        base64.decode(server.openVpnConfigDataBase64),
      );

      final certIsRequired =
          configString.contains('<cert>') ||
          configString.contains('<ca>') ||
          configString.contains('<key>');

      await _openVPN.connect(
        configString,
        server.countryLong,
        username: 'vpn',
        password: 'vpn',
        bypassPackages: [],
        certIsRequired: certIsRequired,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Failed to connect: \$e");
      }
    }
  }

  Future<void> disconnect() async {
    try {
      _openVPN.disconnect();
    } catch (e) {
      if (kDebugMode) {
        print("Failed to disconnect: \$e");
      }
    }
  }

  Future<bool> get isConnected async {
    try {
      return await _openVPN.isConnected();
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _statusController.close();
    _stageController.close();
  }
}
