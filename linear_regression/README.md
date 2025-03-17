# Crop Yield Prediction using Linear Regression

This project trains multiple machine learning models (Linear Regression, Decision Tree, and Random Forest) to predict crop yield based on soil and weather conditions. The best-performing model is saved for future predictions.

## 📂 Project Structure
```
ML_Sumative/
├── linear_regression/
│   ├── data/
│   │   └── crop_yield.csv    # Dataset file (Place your dataset here)
│   ├── train_model.py        # Train models and save the best model
│   ├── prediction.py         # Load the saved model and make predictions
│   ├── requirements.txt      # Required Python libraries
│   ├── README.md             # Project description and usage instructions
│   └── model.pkl             # Saved best model after training (created automatically)
```

## 🚀 How to Use

### **1️⃣ Install Dependencies**
Run:
```sh
pip install -r linear_regression/requirements.txt
```

### **2️⃣ Train the Model**
Run:
```sh
# From the ML_Sumative directory
python linear_regression/train_model.py

# OR from inside the linear_regression directory
cd linear_regression
python train_model.py
```

This will:
* Load and preprocess the dataset
* Train **Linear Regression, Decision Tree, and Random Forest** models
* Evaluate their performance using **Mean Squared Error (MSE)**
* Save the best-performing model as `model.pkl`

### **3️⃣ Make Predictions**
Run:
```sh
# From the ML_Sumative directory
python linear_regression/prediction.py

# OR from inside the linear_regression directory
cd linear_regression
python prediction.py
```

This will load the saved model and make a prediction based on sample input.

## 📌 Example Prediction Output
```
Predicted Crop Yield: 12.04
```

## **Final Steps Checklist**

✅ **1. Install Dependencies**
```sh
pip install -r linear_regression/requirements.txt
```

✅ **2. Train the Model**
```sh
python linear_regression/train_model.py
```

✅ **3. Run Predictions**
```sh
python linear_regression/prediction.py
```