# 🌍 World Life Expectancy SQL Analysis

## 📘 Overview
I performed a complete **data cleaning and exploratory SQL analysis** on the *World Life Expectancy* dataset.  
The goal was to clean inconsistent records, impute missing values, and uncover analytical insights into how life expectancy has changed globally over time.

## 🗂 Dataset
- **Source:** World Life Expectancy dataset (CSV imported into MySQL)
- **Rows:** ~2,000+
- **Columns:** Country, Year, Status, Life Expectancy, GDP, BMI, Adult Mortality
- **Database:** world_life_expectancy schema

## 🧹 Data Cleaning & Preparation
### 1. Removed Duplicate Records
Used ROW_NUMBER() to identify and delete duplicate (Country, Year) combinations.
### 2. Fixed Missing or Empty Status Values
Filled missing Status values (Developed / Developing) based on similar country records.
### 3. Imputed Missing Life Expectancy Values
Estimated missing life expectancy using the mean of adjacent years for the same country.

## 📊 Descriptive SQL Analysis
Includes queries for:
- Life Expectancy Improvements by Country
- Global Trend by Year
- GDP vs Life Expectancy Correlation
- BMI Correlation
- Rolling Mortality Analysis

## 🧠 SQL Techniques Used
- ROW_NUMBER() and window functions
- Multi-table JOIN updates
- Aggregations and HAVING filters
- CASE logic and ROUND formatting

## 📈 Power BI Integration
I visualized the SQL outputs in Power BI to show:
- Average Life Expectancy by Country and Year
- GDP vs Life Expectancy Scatter Chart
- Developed vs Developing Comparison
- BMI vs Life Expectancy Trendline
- Mortality Rolling Sum Visualization

Power BI dashboard features include slicers, interactive filters, and color-coded visuals.  
(*Power BI file placeholder in /PowerBI/ folder*)

## 🧾 Key Insights
- Global life expectancy steadily increased between 2000–2015.
- Developed countries maintained higher averages with smaller growth margins.
- Developing nations improved faster.
- GDP correlates positively with life expectancy.
- Mortality declines mirror life expectancy growth.

## 🗂 Repository Structure
```
/sql
 ├── World_LIfe_Expectancy.sql        # Data cleaning and preparation
 ├── World LIFE EXPECTANCY EDA.sql    # Analytical queries and descriptive insights
/PowerBI
 ├── World_Life_Expectancy_Dashboard.pbix
```

## 🚀 Next Steps
- Automate ETL with Python/dbt
- Connect Power BI directly to SQL
- Add WHO health data for deeper insights

## 📜 License
MIT License

### ✨ Author
**Joel Martin**  
*Business Analytics Graduate | Aspiring Data Engineer / Analyst*  
📍 Melbourne, Australia
