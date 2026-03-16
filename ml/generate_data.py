import pandas as pd
import numpy as np
import random
import os

def generate_http_traffic(num_samples=1000, anomaly_ratio=0.05):
    data = []
    
    # Common user agents
    user_agents = [
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.98 Safari/537.36",
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36"
    ]
    
    # Common paths
    paths = ["/", "/index.html", "/api/v1/user", "/api/v1/product", "/login", "/search"]
    
    for i in range(num_samples):
        is_anomaly = random.random() < anomaly_ratio
        
        method = random.choice(["GET", "POST", "PUT"])
        path = random.choice(paths)
        user_agent = random.choice(user_agents)
        content_length = random.randint(100, 2000)
        
        # Simulate normal features
        time_of_day = random.randint(0, 23)
        request_rate = random.gauss(10, 2) # Typical requests/sec
        
        if is_anomaly:
            # Simulate anomalies
            attack_type = random.choice(["SQLi", "XSS", "Brute Force"])
            if attack_type == "SQLi":
                path = f"/api/v1/user?id=1' OR '1'='1"
                content_length = random.randint(2000, 5000)
            elif attack_type == "XSS":
                path = f"/search?q=<script>alert('xss')</script>"
                content_length = random.randint(500, 1000)
            elif attack_type == "Brute Force":
                path = "/login"
                method = "POST"
                request_rate = random.gauss(100, 10) # High request rate
            
            label = 1
            anomaly_info = attack_type
        else:
            label = 0
            anomaly_info = "Normal"
            
        data.append({
            "method": method,
            "path": path,
            "user_agent": user_agent,
            "content_length": content_length,
            "time_of_day": time_of_day,
            "request_rate": request_rate,
            "is_anomaly": label,
            "attack_type": anomaly_info
        })
        
    df = pd.DataFrame(data)
    os.makedirs("data", exist_ok=True)
    df.to_csv("data/traffic_data.csv", index=False)
    print(f"Generated {num_samples} samples with {df['is_anomaly'].sum()} anomalies.")

if __name__ == "__main__":
    generate_http_traffic()
