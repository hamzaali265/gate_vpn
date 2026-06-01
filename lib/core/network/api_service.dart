import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:csv/csv.dart';
import '../../modules/vpn/models/vpn_server.dart';

class ApiService {
  static const String _vpngateUrl = 'http://www.vpngate.net/api/iphone/';

  static final CacheManager _cacheManager = CacheManager(
    Config(
      'vpngate_custom_cache',
      stalePeriod: const Duration(hours: 6),
      maxNrOfCacheObjects: 2, // We only really need 1 file
    ),
  );

  Future<List<VpnServer>> fetchVpnServers({bool forceRefresh = false}) async {
    try {
      File file;

      if (forceRefresh) {
        // Force a fresh download from the network by removing cache first
        await _cacheManager.removeFile(_vpngateUrl);
        file = await _cacheManager.getSingleFile(_vpngateUrl);
      } else {
        // Automatically returns cache if under 6 hours old.
        // If older than 6 hours, it automatically downloads a fresh copy.
        file = await _cacheManager.getSingleFile(_vpngateUrl);
      }

      final body = await file.readAsString();
      return await compute(_parseCsvInBackground, body);
    } catch (e) {
      throw Exception('Failed to fetch VPN servers: $e');
    }
  }

  // Must be a top-level or static function for compute()
  static List<VpnServer> _parseCsvInBackground(String csvBody) {
    List<List<dynamic>> rowsAsListOfValues = Csv().decode(csvBody);
    List<VpnServer> servers = [];

    for (var row in rowsAsListOfValues) {
      if (row.length >= 15 &&
          row[0] != '*vpn_servers' &&
          row[0] != '#HostName') {
        try {
          servers.add(VpnServer.fromCsvRow(row));
        } catch (e) {
          // ignore malformed row
        }
      }
    }

    servers.sort((a, b) => b.score.compareTo(a.score));
    return servers;
  }
}
