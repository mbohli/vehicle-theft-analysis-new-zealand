-- VEHICLE THEFT ANALYSIS - NEW ZEALAND
-- Portfolio SQL

-- Purpose:
-- Analyze historical vehicle theft records to identify
-- geographic, temporal, and vehicle-level patterns.
--
-- Database:
-- stolen_vehicles_db
--
-- Tools:
-- MySQL / MySQL Workbench
-- Tableau
--
-- Workflow:
-- SQL analysis → CSV exports → Tableau analysis & visualization


-- 1. DATABASE SETUP

USE stolen_vehicles_db;

-- 2. INITIAL DATA EXPLORATION
-- Review source tables

SELECT *
FROM stolen_vehicles;
SELECT *
FROM locations;
SELECT *
FROM make_details;

-- Total number of theft records

SELECT
    COUNT(*) AS total_thefts
FROM stolen_vehicles;


-- 3. DATA QUALITY CHECKS

-- Check for missing vehicle IDs
SELECT
    COUNT(*) AS missing_vehicle_id
FROM stolen_vehicles
WHERE vehicle_id IS NULL;

-- Check for duplicate vehicle IDs
SELECT
    vehicle_id,
    COUNT(*) AS record_count
FROM stolen_vehicles
GROUP BY vehicle_id
HAVING COUNT(*) > 1;

-- Check for missing vehicle types
SELECT
    COUNT(*) AS missing_vehicle_type
FROM stolen_vehicles
WHERE vehicle_type IS NULL;

-- Check for missing theft dates
SELECT
    COUNT(*) AS missing_date_stolen
FROM stolen_vehicles
WHERE date_stolen IS NULL;

-- Check for missing location IDs
SELECT
    COUNT(*) AS missing_location_id
FROM stolen_vehicles
WHERE location_id IS NULL;

-- Check for missing make IDs
SELECT
    COUNT(*) AS missing_make_id
FROM stolen_vehicles
WHERE make_id IS NULL;


-- 4. MONTHLY THEFT ANALYSIS
-- Tableau output: monthly_theft.csv

SELECT
    YEAR(date_stolen) AS year,
    MONTH(date_stolen) AS month,
    COUNT(vehicle_id) AS num_theft
FROM stolen_vehicles
GROUP BY
    YEAR(date_stolen),
    MONTH(date_stolen)
ORDER BY
    year,
    month;


-- 5. MONTH-OVER-MONTH THEFT CHANGE
-- Tableau output: MoM change.csv

WITH monthly_theft AS
(
    SELECT
        YEAR(date_stolen) AS year,
        MONTH(date_stolen) AS month,
        COUNT(vehicle_id) AS num_theft
    FROM stolen_vehicles
    GROUP BY
        YEAR(date_stolen),
        MONTH(date_stolen)
)

SELECT
    year,
    month,
    num_theft,
    LAG(num_theft) OVER(ORDER BY year, month) AS prev_month_theft,
    ROUND(((num_theft - LAG(num_theft) OVER(ORDER BY year, month))/LAG(num_theft) OVER(ORDER BY year, month)) * 100,1
    ) AS MoM_change

FROM monthly_theft
ORDER BY
    year,
    month;


-- 6. CHECK FOR INCOMPLETE MONTHS

-- April 2022 contains only part of the month.
-- It is therefore excluded from interpretation of the
-- monthly trend.

SELECT
    MONTH(date_stolen) AS month,
    DAY(date_stolen) AS day
FROM stolen_vehicles
WHERE YEAR(date_stolen) = 2022
  AND MONTH(date_stolen) = 4
ORDER BY day;


-- 7. DAY-OF-WEEK ANALYSIS
-- Tableau output: num_stolen_eachdayofweek.csv

SELECT
    CASE
        WHEN DAYOFWEEK(date_stolen) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(date_stolen) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(date_stolen) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(date_stolen) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(date_stolen) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(date_stolen) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(date_stolen) = 7 THEN 'Saturday'
        ELSE 'Unknown'
    END AS wkday,
    COUNT(vehicle_id) AS num_theft
FROM stolen_vehicles
GROUP BY
    DAYOFWEEK(date_stolen)
ORDER BY
    num_theft DESC;

-- 8. VEHICLE TYPE ANALYSIS

SELECT
    vehicle_type,
    COUNT(vehicle_id) AS num_stolen
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_stolen DESC;


-- 9. VEHICLE AGE ANALYSIS
-- Vehicle age is estimated using the theft year and model year.
SELECT
    vehicle_type,
    ROUND(
        AVG(YEAR(date_stolen) - model_year),1) AS avg_age,
    COUNT(vehicle_id) AS num_stolen
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_stolen DESC;

-- 10. VEHICLE MAKE AND TYPE ANALYSIS
-- Theft volume by vehicle type and make.

SELECT
    sv.vehicle_type,
    md.make_name,
    COUNT(sv.vehicle_id) AS num_stolen
FROM stolen_vehicles sv
LEFT JOIN make_details md
    ON sv.make_id = md.make_id
GROUP BY
    sv.vehicle_type,
    md.make_name
ORDER BY
    sv.vehicle_type,
    num_stolen DESC;


-- 11. TOP MAKES WITHIN VEHICLE TYPES
-- Tableau output:
-- vehicle_type_by_make_and_num_stolen_top2.csv

WITH vehicle_make AS (
    SELECT
        sv.vehicle_type,
        md.make_name,
        COUNT(sv.vehicle_id) AS num_stolen
    FROM stolen_vehicles sv
    LEFT JOIN make_details md
        ON sv.make_id = md.make_id
    WHERE sv.vehicle_type IS NOT NULL
    GROUP BY
        sv.vehicle_type,
        md.make_name),

ranked_makes AS (
    SELECT
        vehicle_type,
        make_name,
        num_stolen,
        ROW_NUMBER() OVER( PARTITION BY vehicle_type ORDER BY num_stolen DESC) AS rank_make
    FROM vehicle_make)

SELECT
    vehicle_type,
    make_name,
    num_stolen,
    rank_make
FROM ranked_makes
WHERE rank_make <= 2
ORDER BY
    vehicle_type,
    rank_make;

-- 12. STANDARD VS LUXURY VEHICLE CLASSIFICATION
-- Tableau output: vehicle_type_standard_vs_luxury.csv

WITH vehicle_make AS(
    SELECT
        sv.vehicle_type,
        md.make_type
    FROM stolen_vehicles sv
    INNER JOIN make_details md
        ON sv.make_id = md.make_id
    WHERE sv.vehicle_type IS NOT NULL)

SELECT
    vehicle_type,
    ROUND(100 * SUM(
            CASE
                WHEN make_type = 'Standard' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS pct_standard,

    ROUND(
        100 * SUM(
            CASE
                WHEN make_type = 'Luxury' THEN 1
                ELSE 0
            END) / COUNT(*),1) AS pct_luxury
FROM vehicle_make
GROUP BY vehicle_type;

-- 13. REGIONAL THEFT ANALYSIS
-- Tableau output: regional_theft.csv

SELECT
    l.region,
    COUNT(sv.vehicle_id) AS num_theft,
    l.population
FROM stolen_vehicles sv
LEFT JOIN locations l
    ON sv.location_id = l.location_id
GROUP BY
    l.region,
    l.population
ORDER BY
    num_theft DESC;

-- The regional output contains both theft counts and population.

/* The population-adjusted theft rate was calculated in Tableau:
using (SUM([num_theft]) / SUM([population])) * 1000
 This produced the theft-rate-per-1,000-residents visualization. */


-- 14. REGIONAL THEFT BY VEHICLE MAKE
-- Tableau output: regional_theft_by_vehicle_make.csv

SELECT
    l.region,
    md.make_name,
    COUNT(sv.vehicle_id) AS num_theft
FROM locations l
LEFT JOIN stolen_vehicles sv
    ON l.location_id = sv.location_id
LEFT JOIN make_details md
    ON sv.make_id = md.make_id
GROUP BY
    l.region,
    md.make_name
ORDER BY
    l.region,
    num_theft DESC;

-- 15. TOP TWO VEHICLE MAKES WITHIN EACH REGION
-- Tableau output: top2_regionaltheft_by_vehicle_make.csv

WITH regional_make AS(
    SELECT
        l.region,
        md.make_name,
        COUNT(sv.vehicle_id) AS num_theft
    FROM locations l
    LEFT JOIN stolen_vehicles sv
        ON l.location_id = sv.location_id
    LEFT JOIN make_details md
        ON sv.make_id = md.make_id
    GROUP BY
        l.region,
        md.make_name),
ranked_make AS(
    SELECT
        region,
        make_name,
        num_theft,
        ROW_NUMBER() OVER(PARTITION BY region ORDER BY num_theft DESC) AS rank_make
    FROM regional_make)

SELECT
    region, make_name, num_theft, rank_make
FROM ranked_make
WHERE rank_make <= 2
ORDER BY
    region,
    rank_make;


-- 16. REGIONAL THEFT BY VEHICLE TYPE
-- Tableau output: regional_type_theft.csv

SELECT
    l.region,
    sv.vehicle_type,
    COUNT(sv.vehicle_id) AS num_theft
FROM locations l
LEFT JOIN stolen_vehicles sv
    ON l.location_id = sv.location_id
GROUP BY
    l.region, sv.vehicle_type
ORDER BY
    l.region, num_theft DESC;

-- 17. TOP FIVE VEHICLE TYPES WITHIN EACH REGION
-- Tableau output: top5_regional_theft_by_vehicle_type.csv

WITH regional_type AS
(SELECT
        l.region,
        sv.vehicle_type,
        COUNT(sv.vehicle_id) AS num_theft
    FROM locations l
    LEFT JOIN stolen_vehicles sv
        ON l.location_id = sv.location_id
    GROUP BY
        l.region,
        sv.vehicle_type),
ranked_type AS
(SELECT
        region,
        vehicle_type,
        num_theft,
        ROW_NUMBER() OVER( PARTITION BY region ORDER BY num_theft DESC) AS rank_type
    FROM regional_type)

SELECT
    region, vehicle_type, num_theft, rank_type
FROM ranked_type
WHERE rank_type <= 5
ORDER BY
    region,
    rank_type;

-- 18. TOP VEHICLE TYPES AND THEIR LEADING MAKES
/*This analysis identifies leading makes within vehicle types.
The Tableau visualization was narrowed to the leading
vehicle types and their top two makes.*/

WITH vehicle_make AS
(SELECT
        sv.vehicle_type,
        md.make_name,
        COUNT(sv.vehicle_id) AS num_stolen
    FROM stolen_vehicles sv
    LEFT JOIN make_details md
        ON sv.make_id = md.make_id
    WHERE sv.vehicle_type IS NOT NULL
    GROUP BY
        sv.vehicle_type,
        md.make_name),
ranked_makes AS
(SELECT
        vehicle_type,
        make_name,
        num_stolen,
        ROW_NUMBER() OVER(PARTITION BY vehicle_type ORDER BY num_stolen DESC
        ) AS rank_make
    FROM vehicle_make)

SELECT
    vehicle_type,
    make_name,
    num_stolen,
    rank_make
FROM ranked_makes
WHERE rank_make <= 2
ORDER BY
    vehicle_type,
    rank_make;

-- 19. NATIONAL VEHICLE-MAKE ANALYSIS
-- The Tableau analysis used the regional vehicle-make output
-- and aggregated num_theft by make_name across regions.
--
-- This query shows the equivalent calculation directly in SQL.
-- It was not required to produce the original Tableau output.

SELECT
    md.make_name,
    COUNT(sv.vehicle_id) AS num_stolen
FROM stolen_vehicles sv
LEFT JOIN make_details md
    ON sv.make_id = md.make_id
GROUP BY
    md.make_name
ORDER BY
    num_stolen DESC;

-- 20. ANALYTICAL NOTES
/* Vehicle theft counts represent recorded thefts in the dataset.
 
 High theft volume does not necessarily indicate a higher
probability of theft because the analysis does not contain
the number of vehicles in circulation by make, type, or region.
Population-adjusted regional rates provide additional context
when comparing regions with different population sizes.

 April 2022 is incomplete and will not be interpreted as a
complete monthly observation.

Tableau was used for further aggregation, filtering,
calculated fields, and visualization after selected SQL
outputs were exported to CSV.*/
