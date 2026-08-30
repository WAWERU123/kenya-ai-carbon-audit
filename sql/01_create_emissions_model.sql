-- View 1: Core IT & Facility Energy Calculations and Grid Emissions Engine
CREATE OR REPLACE VIEW `kenya-ai-carbon-audit.ai_carbon.emissions_model` AS
WITH energy_calculated AS (
  SELECT 
    w.workload_id,
    w.workload_name,
    w.workload_type,
    w.gpu_model,
    w.gpu_count,
    w.duration_hours,
    (w.gpu_count * w.duration_hours) AS total_gpu_hours,
    g.power_draw_kw,
    -- IT Energy (kWh) = GPU Count * Duration * Power Rating
    (w.gpu_count * w.duration_hours * g.power_draw_kw) AS it_energy_kwh,
    d.datacenter_id,
    d.location_name,
    d.pue,
    d.pue_category,
    -- Facility Energy (kWh) = IT Energy * PUE
    (w.gpu_count * w.duration_hours * g.power_draw_kw * d.pue) AS total_facility_energy_kwh
  FROM 
    `kenya-ai-carbon-audit.ai_carbon.raw_workload_data` w
  JOIN 
    `kenya-ai-carbon-audit.ai_carbon.raw_gpu_data` g ON w.gpu_model = g.gpu_model
  CROSS JOIN 
    `kenya-ai-carbon-audit.ai_carbon.raw_datacenter_data` d
)
SELECT 
  workload_name,
  gpu_model,
  pue_category,
  pue,
  ROUND(total_facility_energy_kwh, 2) AS total_facility_energy_kwh,
  -- Average Grid Emissions (~70 gCO2e/kWh)
  ROUND((total_facility_energy_kwh * 70) / 1000, 2) AS avg_grid_emissions_kg_co2,
  -- Thermal Peaking Marginal Emissions (~650 gCO2e/kWh)
  ROUND((total_facility_energy_kwh * 650) / 1000, 2) AS marginal_thermal_emissions_kg_co2,
  -- Peaking Emissions Gap
  ROUND(((total_facility_energy_kwh * 650) - (total_facility_energy_kwh * 70)) / 1000, 2) AS emissions_gap_kg_co2
FROM 
  energy_calculated;