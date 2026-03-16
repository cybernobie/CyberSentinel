import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/anomaly.dart';

class ThreatFeed extends StatelessWidget {
  const ThreatFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final anomalies = provider.anomalies;
        
        if (anomalies.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(80.0),
              child: Text(
                'No anomalies detected yet...',
                style: TextStyle(
                  color: Colors.white30,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: anomalies.length,
          itemBuilder: (context, index) {
            final anomaly = anomalies[index];
            final isSelected = provider.selectedAnomaly?.id == anomaly.id;

            return InkWell(
              onTap: () => provider.selectAnomaly(anomaly),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFF00F2FF).withOpacity(0.1) 
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.05),
                      width: 1,
                    ),
                    left: isSelected
                        ? const BorderSide(color: Color(0xFF00F2FF), width: 2)
                        : BorderSide.none,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          anomaly.timestamp,
                          style: const TextStyle(
                            color: Color(0xFF00F2FF),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF0055).withOpacity(0.1),
                            border: Border.all(color: const Color(0xFFFF0055)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            anomaly.attackType.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFFFF0055),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      anomaly.path,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: ${(anomaly.confidence * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
