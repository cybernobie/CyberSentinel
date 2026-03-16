import pandas as pd
from sklearn.ensemble import IsolationForest, RandomForestClassifier
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.model_selection import train_test_split
import joblib
import os

def train():
    if not os.path.exists("data/traffic_data.csv"):
        print("Data not found. Run generate_data.py first.")
        return

    df = pd.read_csv("data/traffic_data.csv")
    
    # Feature engineering
    le_method = LabelEncoder()
    df['method_encoded'] = le_method.fit_transform(df['method'])
    
    # Simple path length as a feature
    df['path_length'] = df['path'].apply(len)
    
    # In a real scenario, we'd do more complex NLP on the path and payload
    
    features = ['method_encoded', 'content_length', 'time_of_day', 'request_rate', 'path_length']
    X = df[features]
    y_anomaly = df['is_anomaly']
    y_type = df['attack_type']
    
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    
    # 1. Unsupervised Anomaly Detection (Isolation Forest)
    # This represents the "Baselining" part of the challenge
    iso_forest = IsolationForest(contamination=0.05, random_state=42)
    iso_forest.fit(X_scaled)
    
    # 2. Supervised Classifier for Attack Classification
    # Filter only anomalies for training the classifier or use all data if we have labels
    X_train, X_test, y_train, y_test = train_test_split(X_scaled, y_type, test_size=0.2, random_state=42)
    clf = RandomForestClassifier(n_estimators=100, random_state=42)
    clf.fit(X_train, y_train)
    
    # Save models and encoders
    os.makedirs("ml/models", exist_ok=True)
    joblib.dump(iso_forest, "ml/models/anomaly_detector.joblib")
    joblib.dump(clf, "ml/models/attack_classifier.joblib")
    joblib.dump(scaler, "ml/models/scaler.joblib")
    joblib.dump(le_method, "ml/models/le_method.joblib")
    joblib.dump(features, "ml/models/features.joblib")
    
    print("Models trained and saved in ml/models/")

if __name__ == "__main__":
    train()
