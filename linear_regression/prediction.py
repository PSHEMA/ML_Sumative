import joblib
import numpy as np

# Load the trained model
model_path = "./model.pkl"
scaler_path = "./scaler.pkl"

try:
    model = joblib.load(model_path)
    scaler = joblib.load(scaler_path)
except FileNotFoundError:
    print("Error: Model or scaler file not found.")
    exit()

def predict_yield(features):
    """
    Predict crop yield based on input features.

    :param features: List of feature values
    :return: Predicted yield value
    """
    features = np.array(features).reshape(1, -1)
    
    # Scale input using the same scaler from training
    features_scaled = scaler.transform(features)

    # Debugging: Print input before prediction
    print(f"Original input: {features}")
    print(f"Scaled input: {features_scaled}")

    prediction = model.predict(features_scaled)
    print(f"Model prediction: {prediction}")

    return prediction[0]

# Example usage
if __name__ == "__main__":
    sample_features = [30.5, 75.2, 6.8, 120, 3.5]  # Adjust based on feature order in training
    print(f"Predicted Crop Yield: {predict_yield(sample_features)}")
