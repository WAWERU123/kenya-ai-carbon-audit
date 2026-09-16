🌍 AI Carbon Footprint Audit — Kenya Context

A BigQuery analysis quantifying the energy and carbon cost of AI model training and inference, using Kenya's own grid mix as the sustainability baseline rather than a generic global average.

The Problem

AI models are a black box when it comes to energy. Knowing how many kilograms of CO₂ a single training run produces is hard because the data that would answer it is siloed — hardware specs in one place, data center reports in another, utility grid metrics somewhere else entirely. This audit builds a unified model across all three to close that visibility gap.

Key Findings — The "Kenya Advantage"
Finding	Result
Sample workload energy	322.56 kWh total energy consumed
Grid composition	91.4% renewable (geothermal, hydro, wind)
Carbon status	Low-intensity / sustainable
Emissions vs. coal-heavy grids	~80% reduction in carbon emissions for the same workload
Infrastructure overhead (PUE)	Cooling and facility overhead adds 10–20% on top of raw compute energy

The takeaway: Kenya isn't a compromise location for AI workloads — it's a genuine advantage. Running the same training job on Kenya's ~91% renewable grid instead of a coal-heavy region cuts emissions by roughly 80%, before any change to the code or hardware at all. Infrastructure overhead (cooling, facilities) still matters — it's a real 10–20% tax on top of raw compute — but the grid you choose moves the needle far more than efficiency tuning alone.

Data Architecture

Four data streams unified into a single BigQuery source of truth:

Source	What it captures
Workload Logs	GPU count, run duration, task type
Hardware Specifications	Power draw (kW) mapped to specific GPU models
Infrastructure Efficiency	PUE — the cooling and facility overhead added on top of raw compute
Grid Composition	Renewable (geothermal, wind, hydro) vs. fossil-fuel share of the national grid
Technical Implementation

Core formula: (GPUs × kW × Hours) × PUE = Total kWh

SQL data engineering: a master view joins all four sources and calculates energy per workload in one pass
Data cleaning: used SAFE_CAST and GROUP BY logic to resolve schema inconsistencies and eliminate the row duplication that typically breaks downstream visualizations
BI integration: the BigQuery master view feeds Looker Studio directly, so the sustainability dashboard updates automatically rather than needing a manual export each time
sql
SELECT
  w.workload_id,
  w.workload_name,
  ANY_VALUE(w.gpu_model) AS gpu_model,
  ANY_VALUE(w.workload_type) AS workload_type,
  ANY_VALUE(w.gpu_count * g.power_draw_kw * w.duration_hours * dc.pue)
    AS total_energy_kwh,
  ANY_VALUE(dc.location_name) AS location_name,
  ANY_VALUE(grid_summary.total_renewable_share) AS total_renewable_share,
  ANY_VALUE(grid_summary.total_non_renewable_share) AS total_non_renewable_share
FROM `kenya-ai-carbon-audit.ai_carbon.raw_workload_data` AS w
JOIN `kenya-ai-carbon-audit.ai_carbon.raw_gpu_data` AS g
  ON w.gpu_model = g.gpu_model
CROSS JOIN `kenya-ai-carbon-audit.ai_carbon.raw_datacenter_data` AS dc
CROSS JOIN (
  SELECT
    SUM(CASE WHEN is_renewable THEN share_percentage ELSE 0 END) AS total_renewable_share,
    SUM(CASE WHEN NOT is_renewable THEN share_percentage ELSE 0 END) AS total_non_renewable_share
  FROM `kenya-ai-carbon-audit.ai_carbon.raw_grid_generation`
  WHERE fiscal_year = (
    SELECT MAX(fiscal_year) FROM `kenya-ai-carbon-audit.ai_carbon.raw_grid_generation`
  )
) AS grid_summary
GROUP BY w.workload_id, w.workload_name;

The grid subquery collapses the full generation-source breakdown into a single renewable/non-renewable split before joining — a deliberate fix for a duplicate-row bug where joining against the ungrouped grid table multiplied every workload row by the number of generation sources.

Hardware Impact

Newer, high-efficiency GPUs (H100-class) reduce energy intensity per compute cycle compared to older models — but total consumption still trends upward, since model complexity is growing faster than hardware efficiency gains. Better chips alone don't solve this; the grid and the infrastructure layer both still matter.

Sample Output

Show Image Total energy consumption (kWh) by workload size, from BigQuery.

Tech Stack
Data Warehouse: BigQuery
Query Language: GoogleSQL
Visualization: Looker Studio
Skills demonstrated: data modeling, aggregation logic, sustainability analytics, dashboarding
