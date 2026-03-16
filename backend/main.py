from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn
import os
from inference import AnomalyInference

app = FastAPI(title="ML Anomaly Detection API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class TrafficData(BaseModel):
    method: str
    path: str
    content_length: int
    time_of_day: int
    request_rate: float

# Initialize inference
model_path = "ml/models" if os.path.exists("ml/models") else "../ml/models"
inference_engine = AnomalyInference(model_dir=model_path)

@app.get("/")
async def root():
    return {"message": "ML Anomaly Detection API is running"}

@app.post("/detect")
async def detect(data: TrafficData):
    if not inference_engine.models_loaded:
        inference_engine.load_models()
        if not inference_engine.models_loaded:
            raise HTTPException(status_code=503, detail="ML models not yet available. Train models first.")
            
    result = inference_engine.predict(
        data.method, 
        data.path, 
        data.content_length, 
        data.time_of_day, 
        data.request_rate
    )
    return result

@app.get("/health")
async def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
