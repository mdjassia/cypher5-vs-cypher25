import pandas as pd

# Charger le CSV unique
df = pd.read_csv("./data/supply_chain_data.csv")


# ----------------- Vérification des doublons -----------------
print("Doublons sur SKU :")
print(df[df.duplicated(subset='SKU', keep=False)])

# ----------------- Vérification des valeurs manquantes -----------------
print("\nValeurs manquantes par colonne :")
print(df.isna().sum())

# ----------------- Aperçu statistique -----------------
print("\nStatistiques descriptives :")
print(df.describe(include='all'))

# ----------------- Types de données -----------------
print("\nTypes de colonnes :")
print(df.dtypes)

# ----------------- Valeurs uniques par colonne (utile pour les catégories) -----------------
categorical_columns = ['Product type', 'Availability', 'Customer demographics', 
                       'Shipping carriers', 'Supplier name', 'Location',
                       'Inspection results', 'Transportation modes', 'Routes']
for col in categorical_columns:
    print(f"\nValeurs uniques pour {col} :")
    print(df[col].unique())

# Exemple : renommer des colonnes pour plus de clarté
df.rename(columns={'Customer demographics': 'Customer', 'Shipping carriers': 'Carrier'}, inplace=True)

