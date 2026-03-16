# Technical Documentation - ML Anomaly Detection Module

## 1. Architecture Overview
The system follows a decoupled architecture consisting of a Machine Learning engine, a RESTful API, and a Flutter-based monitoring dashboard.

### 1.1 Data Pipeline
1. **Ingestion**: Raw HTTP request parameters (Method, Path, Content-Length, Rate) are received.
2. **Feature Engineering**: 
   - Label encoding for categorical data (e.g., GET/POST).
   - Numerical scaling using `StandardScaler`.
   - Feature derivation (e.g., Path Length).
3. **Inference**: Parallel processing through an Anomaly Detector and an Attack Classifier.
4. **Export**: Generation of ModSecurity compatible rules.

## 2. Machine Learning Models

### 2.1 Anomaly Detection (Baselining)
- **Model**: Isolation Forest.
- **Why**: Excellent for high-dimensional data and handles non-linear relationships well. It works by isolating observations by randomly selecting a feature and then randomly selecting a split value.
- **Function**: Establish the "Normal" behavior boundary.

### 2.2 Attack Classification
- **Model**: Random Forest Classifier.
- **Why**: Robust to noise and provides feature importance, which helps in explainability.
- **Classes**: SQL Injection (SQLi), Cross-Site Scripting (XSS), Brute Force, and Normal.

### 2.3 Explainability
- Currently implemented using feature-based heuristics and model outputs. Provides a human-readable string explaining the nature of the detected anomaly.

## 3. Performance Considerations
- **Inference Latency**: Average < 15ms per request.
- **Throughput**: Capable of handling hundreds of requests per second on standard hardware due to the lightweight nature of tree-based models compared to deep learning.

## 4. Integration Logic
The module recommends rules in the **ModSecurity** format:
- `SecRule ARGS "@detectSQLi" ...`
These rules can be directly ingested by WAFs that support the SecRule syntax, allowing for semi-autonomous security policy updates.
