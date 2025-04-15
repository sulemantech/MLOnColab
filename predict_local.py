import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from tensorflow.keras.models import load_model

# --- Step 1: Load the trained model ---
model = load_model("arabic_characters_model.h5")
print("✅ Model loaded successfully.")

# --- Step 2: Define Arabic character labels ---
arabic_characters = ['ا', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر',
                     'ز', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف',
                     'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي']

# --- Step 3: Load and preprocess test data from GitHub ---
print("📥 Loading test data from GitHub...")

# Raw URLs of the CSV files on GitHub
x_test_url = "https://raw.githubusercontent.com/Bilal-Belli/ArabicAlphabetRecognizerCNN/refs/heads/main/Datasets/csvTestImages%203360x1024.csv"
y_test_url = "https://raw.githubusercontent.com/Bilal-Belli/ArabicAlphabetRecognizerCNN/refs/heads/main/Datasets/csvTestLabel%203360x1.csv"

# Load data directly from GitHub
x_test = pd.read_csv(x_test_url, header=None)
y_test = pd.read_csv(y_test_url, header=None)

# Normalize and reshape data
x_test = x_test / 255.0
x_test = x_test.values.reshape(-1, 32, 32, 1)
y_true = y_test.values.flatten()

print(f"🧪 Test samples: {x_test.shape[0]}")

# --- Step 4: Run predictions ---
print("🤖 Predicting on test data...")
y_pred_probs = model.predict(x_test)
y_pred_classes = np.argmax(y_pred_probs, axis=1)

# --- Step 5: Show prediction results for first 25 samples ---
plt.figure(figsize=(15, 15))
for i in range(25):
    plt.subplot(5, 5, i + 1)
    img = x_test[i].reshape(32, 32).T  # transpose for correct orientation
    true_lbl = arabic_characters[y_true[i] - 1]
    pred_lbl = arabic_characters[y_pred_classes[i] - 1]
    plt.imshow(img, cmap='gray')
    plt.title(f'True: {true_lbl}\nPred: {pred_lbl}')
    plt.axis('off')

plt.tight_layout()
plt.show()
