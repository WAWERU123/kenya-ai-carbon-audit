--- View 2: Power Sourcing Strategy Comparison
CREATE OR REPLACE VIEW `kenya-ai-carbon-audit.ai_carbon.scenario_results` AS
SELECT 
  workload_name,
  pue_category,
  pue,
  total_facility_energy_kwh,
  ROUND((total_facility_energy_kwh * 70) / 1000, 2) AS strategy_avg_grid_kg_co2,
  ROUND((total_facility_energy_kwh * 650) / 1000, 2) AS strategy_thermal_peak_kg_co2,
  ROUND((total_facility_energy_kwh * 15) / 1000, 2) AS strategy_renewable_ppa_kg_co2,
  ROUND((total_facility_energy_kwh * 40) / 1000, 2) AS strategy_hybrid_bess_kg_co2
FROM 
  `kenya-ai-carbon-audit.ai_carbon.emissions_model`;