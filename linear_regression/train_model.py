import pandas as pd
import numpy as np
import joblib
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import SGDRegressor
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error

# Load dataset
file_path = "data/crop_yield.csv"
df = pd.read_csv(file_path)

# Data Preprocessing
df.dropna(inplace=True)  # Remove missing values

X = df.drop(columns=["yeild"])  # Features
y = df["yeild"]  # Target variable

scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)  # Standardize features

# Split into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)

# Train Models
lr_model = SGDRegressor(max_iter=1000, learning_rate='optimal')
dt_model = DecisionTreeRegressor()
rf_model = RandomForestRegressor(n_estimators=100)

lr_model.fit(X_train, y_train)
dt_model.fit(X_train, y_train)
rf_model.fit(X_train, y_train)

# Predictions
lr_pred = lr_model.predict(X_test)
dt_pred = dt_model.predict(X_test)
rf_pred = rf_model.predict(X_test)

# Evaluate Models
lr_mse = mean_squared_error(y_test, lr_pred)
dt_mse = mean_squared_error(y_test, dt_pred)
rf_mse = mean_squared_error(y_test, rf_pred)

print(f"Linear Regression MSE: {lr_mse}")
print(f"Decision Tree MSE: {dt_mse}")
print(f"Random Forest MSE: {rf_mse}")

# Select the best model (lowest MSE)
best_model = min([(lr_model, lr_mse), (dt_model, dt_mse), (rf_model, rf_mse)], key=lambda x: x[1])[0]

# Save the best model
model_path = "./model.pkl"
joblib.dump(best_model, model_path)
print(f"Best model saved at {model_path}")
