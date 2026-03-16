import 'dart:async';
import 'package:flutter/material.dart';
import '../models/anomaly.dart';
import '../services/api_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Anomaly> _anomalies = [];
  List<TrafficDataPoint> _trafficData = [];
  Anomaly? _selectedAnomaly;
  bool _isLive = true;
  Timer? _simulationTimer;

  List<Anomaly> get anomalies => _anomalies;
  List<TrafficDataPoint> get trafficData => _trafficData;
  Anomaly? get selectedAnomaly => _selectedAnomaly;
  bool get isLive => _isLive;

  DashboardProvider() {
    startSimulation();
  }

  void startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_isLive) {
        _simulateTraffic();
      }
    });
  }

  Future<void> _simulateTraffic() async {
    final result = await _apiService.detectAnomaly();
    
    if (result != null) {
      if (result.isAnomaly) {
        _anomalies.insert(0, result);
        if (_anomalies.length > 50) {
          _anomalies = _anomalies.sublist(0, 50);
        }
      }

      _trafficData.add(TrafficDataPoint(
        time: result.timestamp,
        score: result.isAnomaly ? 1.0 : 0.0,
      ));

      if (_trafficData.length > 30) {
        _trafficData = _trafficData.sublist(_trafficData.length - 30);
      }

      notifyListeners();
    }
  }

  void toggleLiveFeed() {
    _isLive = !_isLive;
    notifyListeners();
  }

  void selectAnomaly(Anomaly anomaly) {
    _selectedAnomaly = anomaly;
    notifyListeners();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
