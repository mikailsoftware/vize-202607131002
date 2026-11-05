# 草莓物联网冷链遥测分析

[🇹🇷 Türkçe](../README.md) | [🇬🇧 English](README.en.md) | [🇩🇪 Deutsch](README.de.md) | [🇫🇷 Français](README.fr.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇨🇳 中文](README.zh-CN.md)

本项目将 S1-S6 批次中九个物联网传感器采集的温度遥测数据转换为关系型
结构，并准备在 PostgreSQL 中进行数据质量和异常分析。运营故事、问题定义
和核心研究问题请参阅 [SCENARIO.md](../SCENARIO.md) 及
[SCENARIO.en.md](../scenario/SCENARIO.en.md)；本 README 只说明技术流程。

## 项目范围

- **数据集：** S1-S6 批次、9 个传感器、14,398 条原始时间记录
- **原始结构：** Apache Parquet，37 列
- **处理结果：** 129,582 条长格式测量记录
- **安全温度范围：** 0.0°C-4.0°C
- **目标数据库：** PostgreSQL
- **课程范围：** 期中项目第 3-5 周

当前版本不包含已经完成的 AI 模型。AI 工具使用和学生贡献请见
[AI_BEYAN.md](../AI_BEYAN.md)。

## 数据来源和目录

数据来自 Hugging Face 的
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry)。
六个 Parquet 文件以原始形式保存在 `data/original/` 中，不手工修改。

```text
data/original/                  # S1-S6 原始 Parquet 文件
data/processed/measurements.csv # 长格式输出
python/                         # 读取、校验、转换和导入脚本
sql/                            # PostgreSQL 结构和分析查询
SCENARIO.md                     # 故事、问题和核心问题
AI_BEYAN.md                     # AI 使用声明
```

## 技术流程

1. `python/01_read_files.py` 查找并读取 Parquet 文件。
2. `python/02_verify_schema.py` 校验 S1-S6 是否共享 37 列结构。
3. `python/python03_find_errors.py` 扫描 `-999.00` 硬件错误代码。
4. `python/04_process_data.py` 使用 `pandas.melt()` 将九个传感器列从宽
   格式转换为长格式。
5. `python/05_import_data.py` 将 CSV 导入 PostgreSQL，把空值和 `-999`
   转换为 `NULL`，并校验 129,582 条记录。

一条原始记录包含一个时间点的九个传感器；一条长格式记录代表一次测量：
`14,398 × 9 = 129,582`。

## PostgreSQL、SQL 与数据质量

`sql/sql01_create_tables.sql`、`sql/02_import_data.sql`、
`sql/05_anomaly_thresholds.sql`、`sql/hafta-04.sql`、`sql/hafta-05.sql` 和
`sql/sql06_ai_anomaly_view.sql` 分别覆盖表结构、导入检查、温度阈值及第
4-5 周的分析。AI 视图只是未来工作的准备，不代表已经完成的模型。

`-999.00` 是硬件故障代码，不是真实温度；在 SQL 中按 `NULL` 处理，以免
影响平均值和阈值判断。安全范围为 0.0°C-4.0°C，超过 8.0°C 视为关键
损失阈值。

## 可复现运行

在项目根目录执行：

```bash
python python/01_read_files.py
python python/02_verify_schema.py
python python/python03_find_errors.py
python python/04_process_data.py
python python/05_import_data.py
```

最后一步可通过 `PGHOST`、`PGPORT`、`PGDATABASE`、`PGUSER` 和
`PGPASSWORD` 设置 PostgreSQL 连接参数。默认数据库为 `strawberry_db`，
端口为 `5432`。导入完成后，使用 PostgreSQL 客户端执行 SQL 文件。
