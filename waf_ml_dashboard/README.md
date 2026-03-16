# WAF ML Dashboard - Flutter

A Flutter application for ML-Enabled Network Anomaly Detection with a premium dark theme UI.

## Features

- **Real-time Traffic Monitoring**: Live chart showing anomaly scores
- **Threat Detection Feed**: Scrollable list of detected anomalies
- **Explainable AI**: Human-readable reasoning for each detection
- **Rule Recommendations**: Auto-generated ModSecurity rules
- **Premium UI**: Dark theme with glassmorphism effects
- **Cross-platform**: Runs on Windows, Web, Android, and iOS

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Backend API running at `http://localhost:8000`

## Installation

```bash
cd waf_ml_dashboard
flutter pub get
```

## Running the App

### Windows
```bash
flutter run -d windows
```

### Web
```bash
flutter run -d chrome
```

### Android/iOS
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── anomaly.dart            # Data models
├── services/
│   └── api_service.dart        # Backend API communication
├── providers/
│   └── dashboard_provider.dart # State management
├── screens/
│   └── dashboard_screen.dart   # Main dashboard UI
└── widgets/
    ├── glass_card.dart         # Glassmorphism card
    ├── traffic_chart.dart      # Traffic monitoring chart
    ├── threat_feed.dart        # Threat detection feed
    └── insight_panel.dart      # Explainable AI panel
```

## Dependencies

- `http`: API communication
- `fl_chart`: Beautiful charts
- `google_fonts`: Inter font family
- `provider`: State management

## Backend Integration

The app connects to the FastAPI backend at `http://localhost:8000/detect`.

Make sure the backend is running before starting the Flutter app:

```bash
cd ../backend
python main.dart
```

## Screenshots

The Flutter app replicates the HTML dashboard with:
- Same premium dark theme
- Real-time traffic simulation
- Threat detection and classification
- Explainable AI insights
- Rule recommendations
