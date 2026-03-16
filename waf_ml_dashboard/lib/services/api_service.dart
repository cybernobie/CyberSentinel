import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/anomaly.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  Future<Anomaly?> detectAnomaly() async {
    try {
      // Simulate traffic similar to HTML version
      final paths = ["/", "/api/v1/user", "/login", "/search", "/admin"];
      final methods = ["GET", "POST"];
      
      final forceAttack = Random().nextDouble() < 0.2;
      String path = paths[Random().nextInt(paths.length)];
      String method = methods[Random().nextInt(methods.length)];
      double requestRate = 10 + Random().nextDouble() * 5;
      
      if (forceAttack) {
        final attacks = [
          {"path": "/api/v1/user?id=1' OR '1'='1", "method": "GET"},
          {"path": "/search?q=<script>alert(1)</script>", "method": "GET"},
          {"path": "/login", "method": "POST", "request_rate": 150.0}
        ];
        final attack = attacks[Random().nextInt(attacks.length)];
        path = attack['path'] as String;
        method = attack['method'] as String;
        requestRate = (attack['request_rate'] as double?) ?? requestRate;
      }

      final payload = {
        'method': method,
        'path': path,
        'content_length': 200 + Random().nextInt(1000),
        'time_of_day': DateTime.now().hour,
        'request_rate': requestRate,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/detect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Anomaly.fromJson(data, path);
      }
    } catch (e) {
      print('API Error: $e');
    }
    return null;
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
