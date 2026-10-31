from pathlib import Path
import pandas as pd

# Bu Python dosyasının bulunduğu klasör
script_dir = Path(__file__).resolve().parent

# python klasörünün bir üstü: vize-202607131002
repo_root = script_dir.parent

# Gerçek veri klasörü
data_dir = repo_root / "data" / "original"

# Parquet dosyalarını bul
parquet_files = sorted(data_dir.glob("*.parquet"))

print(f"Target directory: {data_dir}")
print(f"Total files found: {len(parquet_files)}")

for file_path in parquet_files:
    df = pd.read_parquet(file_path)

    print(
        f"File: {file_path.name} | "
        f"Row Count: {len(df)} | "
        f"Column Count: {len(df.columns)}"
    )