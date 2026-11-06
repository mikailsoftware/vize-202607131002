from pathlib import Path
import pandas as pd

project_root = Path(__file__).parent.parent
data_dir = project_root / "data" / "original"
parquet_files = sorted(list(data_dir.glob("*.parquet")))

print("Dosyalardaki -999 Sensor Hata Kodlari Taraniyor...\n" + "-" * 50)
total_error_codes = 0

for f in parquet_files:
    df = pd.read_parquet(f)
    numeric_df = df.select_dtypes(include=['float64', 'int64'])
    error_instances = (numeric_df == -999).sum().sum()
    total_error_codes += error_instances
    print(f"{f.name}: {error_instances} adet -999 hata kodu bulundu.")

print("-" * 50)
print(f"TOPLAM TESPIT EDILEN HATA KODU (-999): {total_error_codes}")
print("Bu degerler veritabaninda ortalama (AVG) hesaplarini bozmamasi icin NULL yapilacak.")