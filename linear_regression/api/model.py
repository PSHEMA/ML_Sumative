import joblib
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import SGDRegressor
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error

MODEL_PATH = "../model.pkl"
DATA_PATH = "../data/crop_yield.csv"

def train_and_save_model():
    """
    Train models and save the best-performing model.
    """
    df = pd.read_csv(DATA_PATH)
    df.dropna(inplace=True)

    X = df.drop(columns=["yeild"])
    y = df["yeild"]

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)

    lr_model = SGDRegressor(max_iter=1000, learning_rate='optimal')
    dt_model = DecisionTreeRegressor()
    rf_model = RandomForestRegressor(n_estimators=100)

    lr_model.fit(X_train, y_train)
    dt_model.fit(X_train, y_train)
    rf_model.fit(X_train, y_train)

    lr_mse = mean_squared_error(y_test, lr_model.predict(X_test))
    dt_mse = mean_squared_error(y_test, dt_model.predict(X_test))
    rf_mse = mean_squared_error(y_test, rf_model.predict(X_test))

    best_model = min([(lr_model, lr_mse), (dt_model, dt_mse), (rf_model, rf_mse)], key=lambda x: x[1])[0]
    joblib.dump(best_model, MODEL_PATH)

    return {"message": "Training complete. Best model saved!"}

def predict_yield(features):
    """
    Predict crop yield based on input features.
    :param features: List of feature values
    :return: Predicted yield value
    """
    model = joblib.load(MODEL_PATH)
    features = np.array(features).reshape(1, -1)
    prediction = model.predict(features)
    return prediction[0]
