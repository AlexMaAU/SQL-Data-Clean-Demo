# Data Cleaning

SELECT * FROM layoffs;

-- CREATE a staging table to prevent error, don't edit original table data
CREATE TABLE layoff_staging  
LIKE layoffs;  

INSERT INTO layoff_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoff_staging;

-- Remove Deplicates
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num  
FROM layoff_staging;

# data with duplicate values
SELECT *
FROM (
	SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num 
	FROM layoff_staging
) AS subquery
WHERE row_num > 1;

-- check one of columns with multiple records
SELECT *
FROM layoff_staging
WHERE company = 'Oda';

SELECT *
FROM (
	SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, `date`, country, funds_raised_millions) AS row_num 
	FROM layoff_staging
) AS subquery
WHERE row_num > 1;

SELECT *
FROM layoff_staging
WHERE company = 'Casper' OR company = 'Cazoo' OR company = 'Hibob' OR company = 'Wildlife Studios' OR company = 'Yahoo'
ORDER BY company;

-- 2 data rows duplicated - 9/14/2021
SELECT *
FROM layoff_staging
WHERE company = 'Casper'
ORDER BY company;

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoff_staging2
SELECT *
FROM (
	SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, `date`, country, funds_raised_millions) AS row_num 
	FROM layoff_staging
) AS subquery;

SELECT * FROM layoff_staging2;

SELECT *
FROM layoff_staging2
WHERE row_num > 1;