from pathlib import Path
import pandas as pd

project_root = Path(__file__).parent.parent
data_dir = project_root / "data" / "original"
output_dir = project_root / "data" / "processed"
output_dir.mkdir(parents=True, exist_ok=True)

parquet_files = sorted(list(data_dir.glob("*.parquet")))

sensor_columns = [
    'Front_Top', 'Front_Middle', 'Front_Bottom',
    'Middle_Top', 'Middle_Middle', 'Middle_Bottom',
    'Rear_Top', 'Rear_Middle', 'Rear_Bottom'
]

print("Veri Uzun Formata (Melt) Donusturuluyor...")
melted_chunks = []

for f in parquet_files:
    df = pd.read_parquet(f)
    # Dosya isminden S1, S2 gibi shipment_id cikar
    shipment_code = f.stem.split("-")[0].upper()
    df['shipment_id'] = shipment_code
    
    # 9 sensor sutununu satir satir uzat
    melted = df.melt(
        id_vars=['shipment_id', 'Time'],
        value_vars=[col for col in sensor_columns if col in df.columns],
        var_name='sensor_id',
        value_name='temp_c'
    )
    melted_chunks.append(melted)

final_df = pd.concat(melted_chunks, ignore_index=True)
# Zaman sutununu adlandir
final_df.rename(columns={'Time': 'measurement_time'}, inplace=True)

output_file = output_dir / "measurements.csv"
final_df.to_csv(output_file, index=False)

print(f"ISLEM TAMAMLANDI!")
print(f"Kaydedilen Dosya: {output_file}")
print(f"Toplam Olcum Satiri: {len(final_df)} (14.398 zaman kaydi x 9 sensor = 129.582)")