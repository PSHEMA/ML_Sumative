# 🌱 Crop Yield Prediction API (FastAPI)

This FastAPI app provides:
1. **Train the model** (`POST /train`)
2. **Predict yield** (`POST /predict`)

## 🚀 Installation

```sh
pip install -r requirements.txt
```

## ▶️ Run the API Server

```sh
uvicorn main:app --reload
```

Server runs at: `http://127.0.0.1:8000`

## 📌 API Endpoints

### **1️⃣ Home**
```
GET /
```
🔹 Returns a welcome message.

### **2️⃣ Train Model**
```
POST /train
```
🔹 Trains models and saves the best one.

### **3️⃣ Predict Crop Yield**
```
POST /predict
```
🔹 Request:
```json
{
  "features": [30.5, 75.2, 6.8, 120, 3.5]
}
```
🔹 Response:
```json
{
  "prediction": 8.139184100405267
}
```

## 📜 API Documentation

FastAPI auto-generates docs:
* **Swagger UI**: http://127.0.0.1:8000/docs
* **Redoc UI**: http://127.0.0.1:8000/redoc

## **Final Steps**

### ✅ **1. Install Dependencies**
```sh
pip install -r summative/linear_regression/api/requirements.txt
```

### ✅ **2. Run FastAPI Server**
```sh
uvicorn main:app --reload
```

### ✅ **3.a Test API using Swagger UI**
```
http://127.0.0.1:8000/docs
```

### ✅ **3.b Test API using Redoc UI**
```
http://127.0.0.1:8000/redoc
```