AI Compute Carbon Audit: Evaluating Kenya as a Low-Carbon Data Centre Location
Executive Summary

This repository contains an end-to-end Scope 2 data transformation and carbon auditing pipeline built in Google BigQuery. The project models under what operational, hardware, and grid conditions Kenya serves as a low-carbon location for artificial intelligence compute workloads, compared to global tech hubs (United States, Ireland, Iceland).

Rather than relying on static averages, the pipeline combines hardware specifications, data center overheads, and utility grid dynamics to evaluate the operational trade-offs of AI model training and inference.

Key Audit Findings
Clean Baseline Advantage: Running a large foundation model training workload (99,840 H100 GPU-hours) on Kenya's baseline grid (~70 gCO2e/kWh) emits 5.63 metric tonnes of CO2e — an 81.8% carbon reduction vs. the US national average and 76.7% vs. Ireland.
The Peaking Risk: Adding continuous 24/7 compute demand during evening peak hours forces local heavy fuel oil (HFO) thermal peakers online (~650 gCO2e/kWh), driving workload emissions up to 52.24 metric tonnes of CO2e — a ~9.3x increase.
PUE Efficiency Leverage: Upgrading facility efficiency from a legacy air-cooled facility (PUE 1.50) to a hyperscale baseline (PUE 1.15) eliminates 24,460.8 kWh of electricity overhead per training run.
The US Tipping Point: Kenya maintains an operational carbon advantage over standard US data centers as long as thermal peaking plants supply less than 54.1% of the data center's total energy intake.
Methodology

Energy demand per workload is derived from GPU power draw (kW) × GPU count × runtime hours — for example, the large foundation-model training scenario uses 512 NVIDIA H100 SXM GPUs at 0.70 kW each over 195 hours (99,840 GPU-hours). This base compute energy is then scaled by a facility PUE multiplier (1.15–1.50 depending on cooling architecture) to account for cooling and facility overhead beyond the compute load itself. The resulting total energy draw is converted to CO2e using location-specific grid carbon intensity: a blended average for steady-state operation, or a marginal "peaking" intensity (~650 gCO2e/kWh) for Kenya, reflecting that incremental demand during evening peaks is met by heavy-fuel-oil thermal plants rather than the geothermal/hydro/wind baseload that otherwise supplies ~85% of Kenya's grid (per Kenya's 2024/2025 generation mix: 39.5% geothermal, 24.2% hydro, 13.2% wind, 8.6% thermal, 10.6% imports, 3.3% solar, 0.6% off-grid). Benchmark comparisons use published national/regional average carbon intensities for the US (384 gCO2e/kWh), Ireland (300 gCO2e/kWh), and Iceland (28 gCO2e/kWh). The US tipping-point threshold (54.1%) is solved algebraically from these same baseline and marginal intensities: the peaking-share fraction at which Kenya's blended emissions rate equals the US average.

Data Architecture

The pipeline ingests four structured source tables — GPU hardware specs (power draw per model), workload scenarios (GPU count and duration per job type), data center scenarios (PUE by facility tier), and benchmark grid locations (carbon intensity for Kenya, the US, Ireland, and Iceland) — plus a fifth table modeling Kenya's actual 2024/2025 generation mix by source. These are joined in BigQuery into three analytical SQL views:

emissions_model — computes IT energy and PUE-adjusted facility energy per workload, then applies Kenya's average-grid and thermal-peaking emissions rates to produce baseline emissions, marginal emissions, and the peaking emissions gap.
scenario_results — extends the same facility-energy figures across four power-sourcing strategies (average grid, thermal peaking, renewable PPA, hybrid BESS) to compare procurement options.
global_benchmark_comparison — applies the large-workload facility energy figure across international grid intensities (Kenya, US, Ireland, Iceland) to produce a direct cross-location emissions comparison.
Implications

Kenya's geothermal- and hydro-heavy baseload gives it a real structural advantage for AI compute siting — but that advantage is conditional, not fixed. It holds only as long as demand stays within what the clean baseload can supply; once thermal peakers are dispatched to cover the gap, the carbon case erodes quickly, and crosses over entirely once peaking supplies more than 54.1% of total facility energy. This suggests the opportunity for Kenya isn't simply "attract data centers," but "attract data centers whose demand profile is shaped to sit under the baseload ceiling" — through demand-response scheduling, on-site storage, or co-location with new renewable capacity, rather than treating grid carbon intensity as a static number.

Data Sources
GPU hardware specifications (power draw, memory, generation)
Workload scenarios (GPU count, duration, workload type)
Data center scenarios (PUE by facility tier and cooling technology)
Benchmark grid locations (carbon intensity for Kenya, US, Ireland, Iceland)
Kenya grid generation mix, fiscal year 2024/2025, by source type
