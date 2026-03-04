# 📉 Global Layoffs Data Cleaning & Exploratory Data Analysis (SQL Project)

## 📌 Project Overview
In this project, I analyzed a global layoffs dataset using **MySQL**.

The project focuses on:

✅ Data Cleaning  
✅ Removing Duplicates  
✅ Standardizing Data  
✅ Handling Null Values  
✅ Exploratory Data Analysis (EDA)  
✅ Window Functions & Ranking  
✅ Time Series & Rolling Calculations  

The dataset covers layoffs from **March 2020 to March 2023**.

---

# 🧹 Data Cleaning Process

## 1️⃣ Removing Duplicates

- Checked for duplicates using `GROUP BY` and `HAVING COUNT(*) > 1`
- Created a cleaned table:

```sql
CREATE TABLE layoffs_2 AS
SELECT DISTINCT * FROM layoffs;
```

- Re-checked duplicates to confirm removal

---

## 2️⃣ Standardizing Data

### ✔ Company
Removed extra spaces:

```sql
UPDATE layoffs_2
SET company = TRIM(company);
```

### ✔ Industry
Converted blank values to NULL and standardized Crypto entries:

```sql
UPDATE layoffs_2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```

### ✔ Country
Standardized country naming:

```sql
UPDATE layoffs_2
SET country = 'United States'
WHERE country LIKE 'United States%';
```

---

## 3️⃣ Handling Null Values

### ✔ Filling Missing Industry (Self Join)

```sql
UPDATE layoffs_2 t1
JOIN layoffs_2 t2
  ON t1.company = t2.company
 AND t1.location = t2.location
 AND t1.country = t2.country
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;
```

### ✔ Removing Irrelevant Rows

```sql
DELETE
FROM layoffs_2
WHERE industry IS NULL;

DELETE
FROM layoffs_2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;
```

---

# 📊 Exploratory Data Analysis (EDA)

## 📅 Date Range

```sql
SELECT MIN(date), MAX(date)
FROM layoffs_2;
```

Result: March 2020 – March 2023

---

## 🏢 Companies with Highest Layoffs

```sql
SELECT company,
       SUM(COALESCE(total_laid_off,0)) AS laid_off
FROM layoffs_2
GROUP BY company
ORDER BY laid_off DESC;
```

Insight: Amazon had the highest total layoffs.

---

## 🏭 Industries with Highest Layoffs

```sql
SELECT industry,
       SUM(COALESCE(total_laid_off,0)) AS laid_off
FROM layoffs_2
GROUP BY industry
ORDER BY laid_off DESC;
```

Insight: Consumer industry experienced the highest layoffs.

---

## 🌍 Locations with Highest Layoffs

```sql
SELECT location,
       SUM(COALESCE(total_laid_off,0)) AS laid_off
FROM layoffs_2
GROUP BY location
ORDER BY laid_off DESC;
```

Insight: SF Bay Area had significantly more layoffs than other regions.

---

## 🚀 Company Stage with Highest Layoffs

```sql
SELECT stage,
       SUM(COALESCE(total_laid_off,0)) AS laid_off
FROM layoffs_2
GROUP BY stage
ORDER BY laid_off DESC;
```

Insight: Post-IPO companies were most affected.

---

## 📆 Yearly Layoff Ranking

```sql
SELECT YEAR(date) AS year,
       SUM(COALESCE(total_laid_off,0)) AS laid_off,
       DENSE_RANK() OVER(ORDER BY SUM(COALESCE(total_laid_off,0)) DESC) AS ranking
FROM layoffs_2
GROUP BY YEAR(date)
ORDER BY laid_off DESC;
```

Insight: 2022 recorded the highest layoffs.

---

# 📈 Time Series Analysis

## 📊 Monthly Layoffs

```sql
SELECT DATE_FORMAT(date, '%m-%Y') AS month_year,
       SUM(COALESCE(total_laid_off,0)) AS laid_off
FROM layoffs_2
GROUP BY DATE_FORMAT(date, '%m-%Y')
ORDER BY 1;
```

---

## 📈 Rolling Total Per Year

```sql
SELECT DATE_FORMAT(date, '%m-%Y') AS month_year,
       SUM(COALESCE(total_laid_off,0)) AS laid_off,
       SUM(SUM(COALESCE(total_laid_off,0))) OVER(
           PARTITION BY YEAR(date)
           ORDER BY YEAR(date), MONTH(date)
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS rolling_total
FROM layoffs_2
GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date), MONTH(date);
```

---

## 🏆 Top 5 Companies Per Year (By Layoffs)

```sql
WITH t1 AS (
    SELECT company,
           YEAR(date) AS year,
           SUM(total_laid_off) AS laid_off,
           DENSE_RANK() OVER(
               PARTITION BY YEAR(date)
               ORDER BY SUM(total_laid_off) DESC
           ) AS ranking
    FROM layoffs_2
    GROUP BY company, year
)
SELECT *
FROM t1
WHERE ranking <= 5
ORDER BY year;
```

---

# 🛠 Skills Demonstrated

- SQL Data Cleaning
- Handling Missing Values
- Removing Duplicates
- Self Joins
- CTE (Common Table Expressions)
- Window Functions
- DENSE_RANK()
- Rolling Aggregations
- Time Series Analysis
- Business Insight Extraction

---

# 📌 Key Insights

- 2022 was the peak year for layoffs.
- Post-IPO companies were hit the hardest.
- SF Bay Area experienced the most layoffs geographically.
- Consumer industry saw the largest workforce reductions.
- Amazon had the highest total layoffs among companies.

---

# 📎 Conclusion

This project demonstrates a complete end-to-end SQL data cleaning and analysis workflow, transforming raw layoff data into meaningful business insights using SQL techniques.
