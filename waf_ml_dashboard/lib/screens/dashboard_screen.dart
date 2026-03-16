import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/traffic_chart.dart';
import '../widgets/threat_feed.dart';
import '../widgets/insight_panel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050510),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2.0,
            colors: [
              const Color(0xFF7000FF).withOpacity(0.15),
              Colors.transparent,
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomRight,
              radius: 2.0,
              colors: [
                const Color(0xFF00F2FF).withOpacity(0.15),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            children: [
              // Navigation Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.shield,
                            color: Color(0xFF00F2FF),
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF00F2FF), Color(0xFF7000FF)],
                            ).createShader(bounds),
                            child: const Text(
                              'WAF ML Module',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00FF80).withOpacity(0.2),
                              border: Border.all(color: const Color(0xFF00FF80)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00FF80),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'ML ACTIVE',
                                  style: TextStyle(
                                    color: Color(0xFF00FF80),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Consumer<DashboardProvider>(
                            builder: (context, provider, child) {
                              return ElevatedButton(
                                onPressed: provider.toggleLiveFeed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  provider.isLive ? 'Live Feed' : 'Paused',
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Dashboard Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 1024;
                      
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          // Traffic Chart
                          SizedBox(
                            width: isWide ? constraints.maxWidth * 0.65 - 8 : constraints.maxWidth,
                            child: GlassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.show_chart,
                                            color: Color(0xFF00F2FF),
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Traffic Baselining (Anomaly Score)',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Monitoring Inbound Requests',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  const TrafficChart(),
                                ],
                              ),
                            ),
                          ),

                          // Status Panel
                          SizedBox(
                            width: isWide ? constraints.maxWidth * 0.35 - 8 : constraints.maxWidth,
                            child: GlassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.verified_user,
                                        color: Color(0xFF00FF80),
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Module Integrity',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Column(
                                            children: [
                                              Text(
                                                '100%',
                                                style: TextStyle(
                                                  color: Color(0xFF00F2FF),
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'RELIABILITY',
                                                style: TextStyle(
                                                  color: Colors.white30,
                                                  fontSize: 10,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Column(
                                            children: [
                                              Text(
                                                '12ms',
                                                style: TextStyle(
                                                  color: Color(0xFF7000FF),
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'LATENCY',
                                                style: TextStyle(
                                                  color: Colors.white30,
                                                  fontSize: 10,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF0055).withOpacity(0.1),
                                      border: Border.all(
                                        color: const Color(0xFFFF0055).withOpacity(0.3),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.warning,
                                              color: Color(0xFFFF0055),
                                              size: 18,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'DANGER ZONE',
                                              style: TextStyle(
                                                color: Color(0xFFFF0055),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Consumer<DashboardProvider>(
                                          builder: (context, provider, child) {
                                            return Text(
                                              'Machine Learning has flagged ${provider.anomalies.length} anomalous activities in the last session.',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.8),
                                                fontSize: 12,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Threat Feed
                          SizedBox(
                            width: isWide ? constraints.maxWidth * 0.5 - 8 : constraints.maxWidth,
                            height: 500,
                            child: GlassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.terminal,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Threat Detection Feed',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Expanded(child: ThreatFeed()),
                                ],
                              ),
                            ),
                          ),

                          // Insight Panel
                          SizedBox(
                            width: isWide ? constraints.maxWidth * 0.5 - 8 : constraints.maxWidth,
                            height: 500,
                            child: GlassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.visibility,
                                        color: Color(0xFF7000FF),
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Explainable AI & Rule Recommendation',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Expanded(child: InsightPanel()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
