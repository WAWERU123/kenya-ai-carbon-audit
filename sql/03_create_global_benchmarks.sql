-- View 3: International Location Comparison
CREATE OR REPLACE VIEW `kenya-ai-carbon-audit.ai_carbon.global_benchmark_comparison` AS
SELECT 
  b.location_name,
  b.carbon_intensity_gco2_kwh,
  b.primary_energy_source,
  80371.2 AS total_facility_energy_kwh,
  ROUND((80371.2 * b.carbon_intensity_gco2_kwh) / 1000, 2) AS emissions_kg_co2,
  ROUND((80371.2 * b.carbon_intensity_gco2_kwh) / 1000000, 2) AS emissions_metric_tonnes,
  ROUND(((80371.2 * b.carbon_intensity_gco2_kwh) - (80371.2 * 70)) / 1000, 2) AS diff_vs_kenya_avg_kg_co2
FROM 
  `kenya-ai-carbon-audit.ai_carbon.raw_benchmark_locations` b;