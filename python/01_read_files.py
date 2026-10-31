from pathlib import Path
import pandas as pd

# 1. Proje ana dizinini betiğin kendi konumuna göre dinamik bul
project_root = Path(__file__).parent.parent
data_dir = project_root / "data" / "original"

# 2. Ham Parquet dosyalarını listele ve sırala
parquet_files = sorted(list(data_dir.glob("*.parquet")))

print(f"Hedef Klasor: {data_dir}")
print(f"Bulunan Dosya Sayisi: {len(parquet_files)}\n" + "-" * 45)

total_rows = 0
for f in parquet_files:
    df = pd.read_parquet(f)
    rows, cols = len(df), len(df.columns)
    total_rows += rows
    print(f"Dosya: {f.name} -> Satir: {rows} | Sutun: {cols}")

print("-" * 45)
print(f"GENEL TOPLAM SATIR SAYISI: {total_rows}")
if total_rows == 14398:
    print("DOGRULAMA BASARILI: 14.398 veri satiri eksiksiz okundu.")