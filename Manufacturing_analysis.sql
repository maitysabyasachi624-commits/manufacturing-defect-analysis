-- Manufacturing Operations Performance & Defect Analysis
-- Dataset: clean_manufacturing_data.csv

-- 1. High-Level KPI Summary (Pass vs Defect)
SELECT 
    DefectStatus,
    COUNT(Batch_ID) AS Total_Batches,
    SUM(ProductionVolume) AS Total_Volume_Produced,
    ROUND(AVG(ProductionCost), 2) AS Avg_Production_Cost,
    ROUND(AVG(DowntimePercentage), 2) AS Avg_Downtime_Pct,
    ROUND(AVG(QualityScore), 2) AS Avg_Quality_Score
FROM manufacturing_data
GROUP BY DefectStatus;

-- 2. Root Cause Driver Analysis (Operational Maintenance & Supply Metrics)
SELECT 
    DefectStatus,
    ROUND(AVG(MaintenanceHours), 2) AS Avg_Maintenance_Hours,
    ROUND(AVG(SupplierQuality), 2) AS Avg_Supplier_Quality,
    ROUND(AVG(DeliveryDelay), 2) AS Avg_Delivery_Delay_Days,
    ROUND(AVG(EnergyEfficiency), 2) AS Avg_Energy_Efficiency
FROM manufacturing_data
GROUP BY DefectStatus;

-- 3. Financial Excess Loss Calculation
SELECT 
    COUNT(Batch_ID) AS Defective_Batches,
    ROUND(AVG(ProductionCost), 2) AS Defect_Avg_Cost,
    ROUND((SELECT AVG(ProductionCost) FROM manufacturing_data WHERE DefectStatus = 0), 2) AS Normal_Avg_Cost,
    ROUND(
        (AVG(ProductionCost) - (SELECT AVG(ProductionCost) FROM manufacturing_data WHERE DefectStatus = 0)) 
        * COUNT(Batch_ID), 2
    ) AS Estimated_Excess_Cost_Impact
FROM manufacturing_data
WHERE DefectStatus = 1;