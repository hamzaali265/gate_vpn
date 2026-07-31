import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/vpn_state.dart';
import '../logic/vpn_notifier.dart';

final vpnProvider = NotifierProvider<VpnNotifier, VpnState>(() {
  return VpnNotifier();
});
