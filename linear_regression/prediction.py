import joblib
import numpy as np

# Load the trained model
model_path = "./model.pkl"
model = joblib.load(model_path)

def predict_yield(features):
    """
    Predict crop yield based on input features.
    
    :param features: List of feature values
    :return: Predicted yield value
    """
    features = np.array(features).reshape(1, -1)
    prediction = model.predict(features)
    return prediction[0]

# Example usage
if __name__ == "__main__":
    sample_features = [30.5, 75.2, 6.8, 120, 3.5]
    print(f"Predicted Crop Yield: {predict_yield(sample_features)}")
