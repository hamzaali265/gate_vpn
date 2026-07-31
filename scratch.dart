import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

void main() async {
  final response = await http.get(Uri.parse('https://www.vpngate.net/api/iphone/'));
  if (response.statusCode == 200) {
    String csvData = response.body;
    List<String> lines = csvData.split('\n');
    if (lines.length > 2) {
      lines = lines.sublist(1); // skip the first line
      csvData = lines.join('\n');
    }
    List<List<dynamic>> rows = CsvCodec().decoder.convert(csvData);
    if (rows.length > 1) {
      String base64Config = rows[1][14].toString();
      String configString = utf8.decode(base64.decode(base64Config));
      print(configString);
    }
  }
}
