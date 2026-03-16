import joblib
import pandas as pd
import numpy as np
import os

class AnomalyInference:
    def __init__(self, model_dir="ml/models"):
        self.model_dir = model_dir
        self.load_models()
        
    def load_models(self):
        try:
            self.iso_forest = joblib.load(os.path.join(self.model_dir, "anomaly_detector.joblib"))
            self.clf = joblib.load(os.path.join(self.model_dir, "attack_classifier.joblib"))
            self.scaler = joblib.load(os.path.join(self.model_dir, "scaler.joblib"))
            self.le_method = joblib.load(os.path.join(self.model_dir, "le_method.joblib"))
            self.features = joblib.load(os.path.join(self.model_dir, "features.joblib"))
            self.models_loaded = True
        except Exception as e:
            print(f"Error loading models: {e}")
            self.models_loaded = False
            
    def predict(self, method, path, content_length, time_of_day, request_rate):
        if not self.models_loaded:
            return {"error": "Models not loaded"}
            
        # Preprocess
        try:
            method_encoded = self.le_method.transform([method])[0]
        except:
            method_encoded = 0 # Default if unseen
            
        path_length = len(path)
        
        X = pd.DataFrame([[method_encoded, content_length, time_of_day, request_rate, path_length]], 
                         columns=self.features)
        X_scaled = self.scaler.transform(X)
        
        # Detection
        is_anomaly_raw = self.iso_forest.predict(X_scaled)[0]
        is_anomaly = True if is_anomaly_raw == -1 else False
        
        # Classification
        attack_type = self.clf.predict(X_scaled)[0]
        
        # Confidence (if available) - just dummy for now or use clf probabilities
        probabilities = self.clf.predict_proba(X_scaled)[0]
        max_prob = np.max(probabilities)
        
        # Rule Recommendation
        recommended_rule = self.generate_rule(is_anomaly, attack_type, method, path)
        
        return {
            "is_anomaly": is_anomaly,
            "attack_type": attack_type,
            "confidence": float(max_prob),
            "recommended_rule": recommended_rule,
            "explainability": f"Request to {path} flagged due to {attack_type} pattern."
        }
        
    def generate_rule(self, is_anomaly, attack_type, method, path):
        if not is_anomaly or attack_type == "Normal":
            return None
            
        if attack_type == "SQLi":
            return f'SecRule ARGS "@detectSQLi" "id:1001,phase:2,deny,log,msg:\'Potential SQL Injection in {path}\'"'
        elif attack_type == "XSS":
            return f'SecRule ARGS "@detectXSS" "id:1002,phase:2,deny,log,msg:\'Potential XSS in {path}\'"'
        elif attack_type == "Brute Force":
            return f'SecRule REQUEST_METHOD "POST" "id:1003,phase:1,deny,log,msg:\'Rate limit exceeded for {path}\'"'
        
        return f'SecRule REQUEST_URI "{path}" "id:1000,phase:1,deny,log,msg:\'Anomalous activity detected\'"'

if __name__ == "__main__":
    # Test
    inf = AnomalyInference()
    if inf.models_loaded:
        print(inf.predict("GET", "/api/v1/user?id=1' OR '1'='1", 2000, 14, 5))
