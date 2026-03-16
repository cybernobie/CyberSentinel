# ML-Enabled Network Anomaly Detection Module (WAF Integration)

## Overview
This project is an intelligent security module developed for the **SWAVLAMBAN 2025 Hackathon Challenge 3**. It leverages Machine Learning to baseline normal network traffic (HTTP) and detect anomalies such as SQL Injection, XSS, and Brute Force attacks. The module provides real-time detection, explainable AI insights, and autonomous security rule recommendations.

## Core Features
- **Network Baselining**: Learns normal traffic patterns using an unsupervised Isolation Forest model.
- **Real-time Anomaly Detection**: High-performance inference engine to flag malicious requests.
- **Attack Classification**: Random Forest Classifier to categorize detected threats.
- **Explainable AI**: Provides human-readable reasoning for every detection (Explainability).
- **Rule Recommendation**: Automatically generates ModSecurity rules for detected attacks.
- **Interactive Dashboard**: A premium, real-time interface for administrators.

## Tech Stack
- **Backend**: FastAPI (Python), Sklearn, Pandas, Joblib.
- **Frontend/Dashboard**: Flutter (Web, Windows, Android), Fl_Chart, Provider.
- **ML Models**: Isolation Forest (Baselining), Random Forest (Classification).

## Prerequisites
- Python 3.9+
- Node.js & npm
- Flutter SDK (3.0.0+)

## Setup & Running

### 1. Backend Setup
```bash
cd backend
pip install -r requirements.txt
# Generate mock data and train models
cd ../
python ml/generate_data.py
python ml/train_model.py
# Start the API
cd backend
python main.py
```

### 2. Flutter Dashboard Setup
```bash
cd waf_ml_dashboard
flutter pub get
flutter run -d chrome
```

## Architecture
1. **Traffic Ingestion**: The API receives HTTP logs/traffic data.
2. **Preprocessing**: Data is scaled and encoded for the ML model.
3. **Detection Pipeline**:
   - **Isolation Forest**: Flags the request if it deviates significantly from the learned baseline.
   - **Classifier**: If flagged, identifies the specific type of attack.
4. **Rule Generation**: Insights are converted into standardized WAF rules (ModSecurity format).
5. **Dashboard Visualization**: Results are pushed to the frontend for real-time monitoring and approval.

## Future Integration
The module is designed to be integrated with open-source WAFs (like ModSecurity or Coraza) via its REST API or by exporting the generated rule sets.
