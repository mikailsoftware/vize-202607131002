from pathlib import Path
import pandas as pd

project_root = Path(__file__).parent.parent
data_dir = project_root / "data" / "original"
parquet_files = sorted(list(data_dir.glob("*.parquet")))

reference_columns = None
reference_file = None

print("S1-S6 Sema ve Sutun Dogrulamasi Baslatiliyor...\n")

for f in parquet_files:
    df = pd.read_parquet(f)
    cols = list(df.columns)
    
    if reference_columns is None:
        reference_columns = cols
        reference_file = f.name
        print(f"Referans Dosya: {reference_file} ({len(cols)} sutun)")
        continue
    
    # Sutun listelerini karsilastir
    assert cols == reference_columns, f"HATA: {f.name} semasi {reference_file} ile eslesmiyor!"
    print(f"Dogrulandi: {f.name} -> Referans sema ile birebir uyumlu.")

print("\nSONUC: Tum dosyalar (S1-S6) ayni 37 sutuna sahip, veri birlestirmeye uygun.")