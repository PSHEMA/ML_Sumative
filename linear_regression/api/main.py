from fastapi import FastAPI
from pydantic import BaseModel
from model import train_and_save_model, predict_yield

app = FastAPI()

class PredictRequest(BaseModel):
    features: list

@app.get("/")
def home():
    return {"message": "Welcome to the Crop Yield Prediction API"}

@app.post("/train")
def train_model():
    return train_and_save_model()

@app.post("/predict")
def predict(data: PredictRequest):
    prediction = predict_yield(data.features)
    return {"prediction": prediction}
