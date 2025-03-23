from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from model import train_and_save_model, predict_yield

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

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