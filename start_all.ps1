# Start Backend and Frontend for ML Anomaly Detection Module

Write-Host "Installing Backend Dependencies..." -ForegroundColor Cyan
pip install -r backend/requirements.txt

Write-Host "Generating Data and Training Models..." -ForegroundColor Cyan
python ml/generate_data.py
python ml/train_model.py

Write-Host "Installing Frontend Dependencies..." -ForegroundColor Cyan
cd frontend
npm install

Write-Host "Starting Everything..." -ForegroundColor Green
Start-Process powershell -ArgumentList "cd backend; python main.py" -NoNewWindow
npm run dev
