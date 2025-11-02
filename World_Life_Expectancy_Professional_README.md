# World Life Expectancy – SQL Data Cleaning and Exploratory Analysis

## Project Overview
This project demonstrates an end-to-end process of data cleaning, transformation, and exploratory data analysis (EDA) using SQL on the World Life Expectancy dataset.  
The objective was to correct inconsistencies, handle missing and duplicate records, and extract insights into how life expectancy has evolved globally in relation to economic and health indicators.

---

## Dataset Details
- **Source:** World Life Expectancy dataset (CSV imported into MySQL)
- **Database:** world_life_expectancy
- **Rows:** Approximately 2,000+
- **Columns:** Country, Year, Status, Life Expectancy, GDP, BMI, Adult Mortality

Each record represents a country's life expectancy and health metrics across multiple years.

---

## Step 1 — Data Cleaning and Preprocessing

### 1.1 Removing Duplicate Records
Duplicates distort averages and create redundant data. Each (Country, Year) combination was verified and deduplicated.

```sql
DELETE FROM world_life_expectancy
WHERE Row_id IN (
  SELECT Row_id FROM (
    SELECT Row_id,
           CONCAT(Country, Year),
           ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year)
           ORDER BY CONCAT(Country, Year)) AS Row_Num
    FROM world_life_expectancy
  ) AS Row_table
  WHERE Row_Num > 1
);
```
**Result:** The dataset contains unique country-year records suitable for longitudinal analysis.

---

### 1.2 Handling Missing Status Values
Some countries were missing their development classification. Missing values were filled based on existing entries of the same country.

```sql
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status = 'Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status = 'Developed';
```
**Result:** All countries are consistently labeled as either Developed or Developing.

---

### 1.3 Imputing Missing Life Expectancy Values
Missing life expectancy values were imputed using the mean of adjacent years for the same country, ensuring temporal continuity.

```sql
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
  ON t1.Country = t2.Country AND t1.YEAR = t2.Year - 1
JOIN world_life_expectancy t3
  ON t1.Country = t3.Country AND t1.YEAR = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2, 1)
WHERE t1.`Life expectancy` = '';
```
**Result:** All missing life expectancy values are logically estimated based on surrounding data points.

---

## Step 2 — Exploratory Data Analysis (EDA)

### 2.1 Life Expectancy Growth by Country
The following query calculates the change in life expectancy per country over the dataset's duration.

```sql
SELECT Country,
       MIN(`Life expectancy`) AS Min_LE,
       MAX(`Life expectancy`) AS Max_LE,
       ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 2) AS Life_Increase_15_years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0 AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_years ASC;
```
**Insight:** Developing countries showed the highest improvement, while developed nations had smaller but steady increases.

---

### 2.2 Global Life Expectancy Trend
Analyzes the global average life expectancy per year.

```sql
SELECT Year, ROUND(AVG(`Life expectancy`), 2) AS Avg_Life_Expectancy
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year;
```
**Insight:** A consistent upward trend was observed, reflecting global health advancements between 2000 and 2015.

---

### 2.3 Correlation Between GDP and Life Expectancy
Investigates whether economic prosperity is linked with longer life expectancy.

```sql
SELECT Country,
       ROUND(AVG(`Life expectancy`),1) AS Life_Expectancy,
       ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Expectancy > 0 AND GDP > 0
ORDER BY Life_Expectancy ASC;
```
**Insight:** Higher GDP values are strongly associated with longer life expectancy.

---

### 2.4 Relationship Between BMI and Life Expectancy
Evaluates how BMI averages relate to overall life expectancy across nations.

```sql
SELECT Country,
       ROUND(AVG(`Life expectancy`),1) AS Life_Expectancy,
       ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Expectancy > 0 AND BMI > 0
ORDER BY BMI ASC;
```
**Insight:** Moderate BMI levels tend to correlate positively with longer life expectancy.

---

### 2.5 Rolling Sum of Adult Mortality
A rolling cumulative sum was computed to observe changes in adult mortality over time.

```sql
SELECT Country, Year, `Life expectancy`, `Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%';
```
**Insight:** Declining mortality rates are consistent with improvements in healthcare and living standards.

---

## Step 3 — SQL Techniques Used
- Window functions such as ROW_NUMBER() and SUM() OVER()
- Multi-table joins for logical updates
- Grouped aggregations and HAVING filters
- Conditional logic using CASE
- Data formatting with ROUND()
- Rolling aggregations for temporal analysis

---

## Step 4 — Power BI Visualization
The cleaned dataset was visualized in Power BI to demonstrate analytical findings through interactive dashboards.

### Dashboard Highlights
- Average Life Expectancy by Year and Country
- GDP vs Life Expectancy Correlation
- Developed vs Developing Country Comparison
- BMI vs Life Expectancy Relationship
- Rolling Mortality Trend Analysis

**Power BI Features**
- Interactive slicers for country, region, and year
- Dynamic filters for GDP and Status
- Tooltips displaying statistical details
- Color-coded metrics for clearer interpretation

**Power BI File:** `/PowerBI/World_Life_Expectancy_Dashboard.pbix`

---

## Key Insights
- Global life expectancy has increased consistently since 2000.
- Economic strength (GDP) is a strong determinant of life expectancy.
- Developing countries show faster improvements than developed ones.
- BMI and mortality trends offer valuable health pattern correlations.

---

## Repository Structure
```
/sql
 ├── World_LIfe_Expectancy.sql        # Data cleaning and preprocessing
 ├── World LIFE EXPECTANCY EDA.sql    # Analytical queries and insights
/PowerBI
 ├── World_Life_Expectancy_Dashboard.pbix
README.md
```

---

## Future Enhancements
- Automate data extraction and transformation using Python or dbt.
- Integrate real-time SQL connections for live Power BI reporting.
- Merge WHO datasets for broader health determinants and demographic analysis.

---

## License
MIT License

---

## Author
Joel Martin  
Business Analytics Graduate | Aspiring Data Engineer / Analyst  
Melbourne, Australia
