# 数据卡片——草莓冷链物联网遥测

[🇹🇷 Türkçe](../dataREADME.md) | [🇬🇧 English](dataREADME.en.md) | [🇩🇪 Deutsch](dataREADME.de.md) | [🇫🇷 Français](dataREADME.fr.md) | [🇮🇹 Italiano](dataREADME.it.md) | [🇪🇸 Español](dataREADME.es.md) | [🇨🇳 中文](dataREADME.zh-CN.md)

## 1. 数据集与期中项目范围

本数据卡片描述项目 `vize-202607131002` 在期中项目第 3-5 周中使用的草莓
冷链物联网遥测数据，范围包括数据准备、表设计和 SQL 分析。数据覆盖
S1-S6 批次以及九个传感器的温度测量。

- 原始数据：**14,398 条记录，37 列**
- 传感器：**9 个**
- 长格式：**14,398 × 9 = 129,582 条测量记录**
- 目标数据库：PostgreSQL

## 2. 数据来源与许可

数据来自 Hugging Face 的 [Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry)。
项目记录中的许可为 **Open Data Commons / CC-BY 4.0**，下载日期为
**2026 年 10 月**。原始 Parquet 文件是源数据的不可变副本，不手工修改。

## 3. 质量规则与转换

- `-999`（包括 `-999.00`）是传感器硬件错误代码，不是真实温度，在 SQL
  中保存为 `NULL`。
- 转换后，缺失测量不会影响平均值和阈值判断。
- 九个传感器列从宽格式转换为长格式，每条长格式记录代表一次传感器测量。
- `data/processed/measurements.csv` 预期包含 **129,582** 条记录。

## 4. 温度阈值

- 安全范围：**0.0°C-4.0°C**
- 关键损失阈值：**高于 8.0°C**
- `-999` 值不参与阈值计算。

## 5. 文件结构

```text
vize-202607131002/
├── data/
│   ├── original/                 # S1-S6 原始 Parquet 文件
│   ├── processed/
│   │   └── measurements.csv      # 129,582 条长格式输出
│   └── dataREADME/               # 数据卡片及语言版本
├── python/                       # 读取、校验、转换和导入脚本
├── sql/                          # PostgreSQL 结构和分析查询
├── README.md                     # 主 README
└── SCENARIO.md                  # 期中项目场景
```

## 6. 可复现流程

在项目根目录依次运行 `python/01_read_files.py`、
`python/02_verify_schema.py`、`python/python03_find_errors.py`、
`python/04_process_data.py` 和 `python/05_import_data.py`。流程会读取文件、
校验 37 列结构、识别 `-999`、转换九个传感器并导入 PostgreSQL。
