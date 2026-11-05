# 场景 3：物流配送 x 物联网传感器网络 x 异常检测

[🇹🇷 Türkçe](SCENARIO.md) | [🇬🇧 English](SCENARIO.en.md) | [🇩🇪 Deutsch](SCENARIO.de.md) | [🇫🇷 Français](SCENARIO.fr.md) | [🇮🇹 Italiano](SCENARIO.it.md) | [🇪🇸 Español](SCENARIO.es.md) | [🇨🇳 中文](SCENARIO.zh-CN.md)

**学生编号：** 202607131002  
**课程：** 数据库管理系统（PostgreSQL）

> 本文件说明运营故事、分析问题和项目边界。技术运行细节请参阅
> [README.md](README.md)。

## 1. 运营故事和问题

草莓对温度变化敏感，保质期较短。冷链运输期间，产品规则要求温度保持
在 0.0°C 至 4.0°C。更低的温度可能造成冻伤；更高的温度会加快呼吸、
增加霉菌风险并造成损耗。

物流企业在 S1-S6 批次的容器前部、中部和后部安装九个传感器，持续收集
温度遥测数据。质量团队不仅要知道某个批次是否异常，还要知道问题重复
出现在哪个区域、哪个传感器以及哪些时间段。因此，数据库必须保留可追溯
的测量记录，并把传感器故障与真实温度风险分开。

## 2. 核心研究问题

> **哪些传感器的异常频率最高？这些异常最常出现在一天中的哪些时段？**

辅助问题包括：不同批次、区域（`Front`、`Middle`、`Rear`）和高度
（`Top`、`Middle`、`Bottom`）是否存在差异？异常是否集中在特定小时？
哪些传感器最常出现 `-999.00` 硬件错误代码？

## 3. 目标用户和决策

- **冷链质量检查人员：** 复核关键温度违规和受影响的批次。
- **物流与车队管理人员：** 找出需要维护或加强隔热的区域。
- **数据库课程学生：** 展示关系模型、数据质量处理和可解释的 SQL
  分析。

## 4. 数据背景

项目使用 Hugging Face 的
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry)
中的 S1-S6 Parquet 文件。数据包括 6 个批次、14,398 条原始时间记录、
37 列和九个传感器（`Front_*`、`Middle_*`、`Rear_*`）。宽格式转换为
长格式后得到 129,582 条测量记录。原始文件位于 `data/original/`，输出
位于 `data/processed/measurements.csv`。

## 5. Week 3：表和字段候选

`sensors` 保存 `sensor_id`、`compartment_zone`、`vertical_level` 和
`installed_at`。`measurements` 保存 `id`、`shipment_id`、`sensor_id`、
`temp_c` 和 `measurement_time`。`anomaly_thresholds` 保存 `rule_id`、
`product_name`、`min_safe_temp` 和 `max_safe_temp`；草莓的边界为 0.0°C
和 4.0°C。

## 6. Week 4：预期数据问题

`-999.00` 是硬件故障代码，不是真实温度；导入 SQL 时转换为 `NULL`，并
单独标记为 `SENSOR_FAULT`。`NULL` 表示观测不可用，不表示温度安全。
九个传感器列通过 `pandas.melt()` 转成长格式，六个文件的 37 列结构
需要一致，预期结果为 `14,398 × 9 = 129,582` 条记录。

## 7. Week 5：分析问题

PostgreSQL 查询应按传感器、批次、区域和小时
（`EXTRACT(HOUR FROM measurement_time)`）比较有效测量、故障和异常率。
还应区分低于 0.0°C、4.0°C-8.0°C 以及高于 8.0°C 的读数，并确保
`NULL` 不会扭曲平均值。

## 8. AI 组件策略和边界

AI 组件是 Week 11 的期末规划，在当前期中交付中并未完成。计划中的分类
包括 `NORMAL`、`SENSOR_FAULT`、`COLD_ANOMALY`、
`MODERATE_HEAT_ANOMALY` 和 `CRITICAL_HEAT_BREACH`。未来的
`vw_ai_anomaly_logs` 视图可以读取 `anomaly_thresholds` 中的规则。
AI 使用说明请参阅 [AI_BEYAN.md](AI_BEYAN.md)。

## 9. 期中与期末范围

- **期中项目，Weeks 3-5：** 理解数据和结构、设计表、处理数据质量、
  生成长格式数据、导入 PostgreSQL 并完成可解释的 SQL 分析。
- **期末项目，Week 11：** 实现动态规则视图、扩展异常分类并评估计划中
  的 AI 层。
