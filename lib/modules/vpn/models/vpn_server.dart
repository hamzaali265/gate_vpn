class VpnServer {
  final String hostName;
  final String ip;
  final int score;
  final int ping;
  final int speed;
  final String countryLong;
  final String countryShort;
  final int numVpnSessions;
  final int uptime;
  final int totalUsers;
  final int totalTraffic;
  final String logType;
  final String operator;
  final String message;
  final String openVpnConfigDataBase64;

  String get flagEmoji {
    if (countryShort.length != 2 || countryShort.contains('-')) return '🏳️';
    try {
      final int firstLetter =
          countryShort.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
      final int secondLetter =
          countryShort.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
      return String.fromCharCode(firstLetter) +
          String.fromCharCode(secondLetter);
    } catch (e) {
      return '🏳️';
    }
  }

  VpnServer({
    required this.hostName,
    required this.ip,
    required this.score,
    required this.ping,
    required this.speed,
    required this.countryLong,
    required this.countryShort,
    required this.numVpnSessions,
    required this.uptime,
    required this.totalUsers,
    required this.totalTraffic,
    required this.logType,
    required this.operator,
    required this.message,
    required this.openVpnConfigDataBase64,
  });

  factory VpnServer.fromCsvRow(List<dynamic> row) {
    return VpnServer(
      hostName: row[0].toString(),
      ip: row[1].toString(),
      score: int.tryParse(row[2].toString()) ?? 0,
      ping: int.tryParse(row[3].toString()) ?? 0,
      speed: int.tryParse(row[4].toString()) ?? 0,
      countryLong: row[5].toString(),
      countryShort: row[6].toString(),
      numVpnSessions: int.tryParse(row[7].toString()) ?? 0,
      uptime: int.tryParse(row[8].toString()) ?? 0,
      totalUsers: int.tryParse(row[9].toString()) ?? 0,
      totalTraffic: int.tryParse(row[10].toString()) ?? 0,
      logType: row[11].toString(),
      operator: row[12].toString(),
      message: row[13].toString(),
      openVpnConfigDataBase64: row[14].toString(),
    );
  }
  factory VpnServer.fromJson(Map<String, dynamic> json) {
    return VpnServer(
      hostName: json['hostName'] ?? '',
      ip: json['ip'] ?? '',
      score: json['score'] ?? 0,
      ping: json['ping'] ?? 0,
      speed: json['speed'] ?? 0,
      countryLong: json['countryLong'] ?? '',
      countryShort: json['countryShort'] ?? '',
      numVpnSessions: json['numVpnSessions'] ?? 0,
      uptime: json['uptime'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
      totalTraffic: json['totalTraffic'] ?? 0,
      logType: json['logType'] ?? '',
      operator: json['operator'] ?? '',
      message: json['message'] ?? '',
      openVpnConfigDataBase64: json['openVpnConfigDataBase64'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostName': hostName,
      'ip': ip,
      'score': score,
      'ping': ping,
      'speed': speed,
      'countryLong': countryLong,
      'countryShort': countryShort,
      'numVpnSessions': numVpnSessions,
      'uptime': uptime,
      'totalUsers': totalUsers,
      'totalTraffic': totalTraffic,
      'logType': logType,
      'operator': operator,
      'message': message,
      'openVpnConfigDataBase64': openVpnConfigDataBase64,
    };
  }
}
