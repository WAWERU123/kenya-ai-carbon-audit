Project Case Study: AI Carbon Footprint Audit (Kenya Context)
1. Executive Summary
As AI adoption scales globally, its environmental cost becomes a critical business concern. This project developed a data-driven framework to quantify the carbon impact of AI workloads by integrating hardware energy demands, data center efficiency, and national energy grid data. By focusing on the Kenyan energy context, the audit highlights how regional energy choices can drastically reduce the environmental footprint of high-performance computing.

2. The Problem
AI models are "black boxes" when it comes to energy. It is difficult to know how many kilograms of CO2 are produced by a single training run because the data is siloed across hardware specs, data center reports, and utility grid metrics. I built a Unified Master Model to solve this visibility gap.

3. Data Architecture
I integrated four distinct data streams within Google BigQuery to create a single source of truth:

Workload Logs: Tracked GPU count, duration, and task type.
Hardware Specifications: Mapped GPU models to their specific power draw (kW).
Infrastructure Efficiency: Applied PUE (Power Usage Effectiveness) to account for data center cooling overhead.
Grid Composition: Analyzed the real-time mix of renewable (Geothermal, Wind, Hydro) vs. fossil fuel energy.
4. Technical Implementation (The Process)
To ensure the data was visualization-ready, I performed the following technical steps:

SQL Data Engineering: Created a master view that performed multi-table joins and calculated complex metrics:
Formula: (GPUs × kW × Hours) × PUE = Total kWh
Data Cleaning: Used SAFE_CAST and GROUP BY logic to resolve schema inconsistencies and eliminate data duplication that typically breaks visualization tools.
BI Integration: Connected the BigQuery Master View to Looker Studio to create an automated, real-time sustainability dashboard.
5. Key Findings & The "Kenya Advantage"
Energy Efficiency: Through PUE analysis, I identified that infrastructure overhead adds roughly 10-20% to the raw energy consumption of AI models.
Carbon Decoupling: The audit proved that Kenya is a premier location for "Green AI." Because the grid is ~90% renewable, training a model in Kenya results in an 80% reduction in carbon emissions compared to traditional coal-heavy data regions.
Hardware Impact: Transitioning from older GPU models to high-efficiency hardware (like H100s) reduced energy intensity per compute cycle, though total consumption remains high due to increased model complexity.
6. Technical Stack
Data Warehouse: BigQuery
Query Language: GoogleSQL
Visualization: Looker Studio
Skills Demonstrated: Data Modeling, Aggregation Logic, Sustainability Analytics, Dashboarding.
7. Visual Sample (Example Result)
Total Energy Consumed: 322.56 kWh (per sample workload)
Grid Mix: 91.4% Renewable (Geothermal/Hydro/Wind)
Carbon Status: Low-Intensity / Sustainable
