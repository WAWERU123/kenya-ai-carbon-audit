# kenya-ai-carbon-audit
BigQuery data pipeline modeling AI compute energy and carbon emissions in Kenya. Transforms raw grid, GPU power, and data center efficiency data into analytical SQL views to evaluate grid strategy and international benchmarks
# AI Compute Carbon Audit: Evaluating Kenya as a Low-Carbon Data Centre Location

## Executive Summary
This repository contains an end-to-end Scope 2 data transformation and carbon auditing pipeline built in **Google BigQuery**. The project models under what operational, hardware, and grid conditions Kenya serves as a low-carbon location for artificial intelligence compute workloads compared to global tech hubs (United States, Ireland, Iceland).

Rather than relying on static averages, the pipeline combines hardware specifications, data center overheads, and utility grid dynamics to evaluate the operational trade-offs of AI model training and inference.
## Key Audit Findings
1. **Clean Baseline Advantage:** Running a large foundation model training workload (99,840 H100 GPU-hours) on Kenya's baseline grid (~70 gCO₂e/kWh) emits **5.63 metric tonnes of CO₂e**—achieving an **81.8% carbon reduction vs. the US national average** and **76.7% vs. Ireland**.
2. **The Peaking Risk:** Adding continuous 24/7 compute demand during evening peak hours forces local heavy fuel oil (HFO) thermal peakers online (~650 gCO₂e/kWh), driving workload emissions up to **52.24 metric tonnes of CO₂e** (a ~9.3x increase).
3. **PUE Efficiency Leverage:** Upgrading facility efficiency from a legacy air-cooled facility (PUE 1.50) to a hyperscale baseline (PUE 1.15) eliminates **24,460.8 kWh** of electricity overhead per training run.
4. **The US Tipping Point:** Kenya maintains an operational carbon advantage over standard US data centers as long as thermal peaking plants supply **less than 59.1%** of the data center's total energy intake.

## Data Architecture
The data engine ingests multi-domain raw data sources, performs multi-table JOIN transformations, and builds analytical SQL views inside BigQuery.

     ## Data Architecture

The data engine ingests multi-domain raw data sources, performs multi-table JOIN transformations, and builds analytical SQL views inside BigQuery.

```mermaid
flowchart TD
    A1[Kenya Grid Mix<br/>EPRA Statistics] --> B[LOCAL CSV DATA<br/>Stored in /data]
    A2[AI GPU Specs<br/>H100 / A100 / T4] --> B
    A3[Datacenter PUE<br/>1.15 - 1.50] --> B

    B --> C[(BIGQUERY SANDBOX<br/>ai_carbon dataset)]
    
    C --> D1[emissions_model]
    C --> D2[scenario_results]
    C --> D3[global_benchmark_comparison]
