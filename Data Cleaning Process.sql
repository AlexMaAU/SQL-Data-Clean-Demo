SELECT * FROM layoffs;

# Create staging table to work with
CREATE TABLE practice_layoff_stg1
LIKE layoffs;

INSERT INTO practice_layoff_stg1
SELECT *
FROM layoffs;

SELECT *
FROM practice_layoff_stg1;

# Remove duplicates
SELECT *, ROW_NUMBER() OVER (PARTITION BY company, location, industry, `date`, stage, country) AS duplication
FROM practice_layoff_stg1;

CREATE TABLE practice_layoff_stg2
LIKE practice_layoff_stg1;

ALTER TABLE practice_layoff_stg2
ADD COLUMN duplication INT;

INSERT INTO practice_layoff_stg2
SELECT *
FROM (
	SELECT *, ROW_NUMBER() OVER (PARTITION BY company, location, industry, `date`, stage, country) AS duplication
	FROM practice_layoff_stg1
) AS temp;

SELECT *
FROM practice_layoff_stg2
WHERE duplication > 1;

SELECT *
FROM practice_layoff_stg2
WHERE company = 'Bustle Digital Group';

DELETE FROM practice_layoff_stg2
WHERE duplication > 1;
 
# Standardizing data format
SELECT *
FROM practice_layoff_stg2;

-- fix extra space
SELECT company, TRIM(company)
FROM practice_layoff_stg2;

UPDATE practice_layoff_stg2
SET company = TRIM(company);

UPDATE practice_layoff_stg2
SET location = TRIM(location);

UPDATE practice_layoff_stg2
SET industry = TRIM(industry);

UPDATE practice_layoff_stg2
SET stage = TRIM(stage);

UPDATE practice_layoff_stg2
SET country = TRIM(country);

-- fix company name
SELECT *
FROM practice_layoff_stg2
WHERE company LIKE '&%';

SELECT company, replace(company, '&', '')
FROM practice_layoff_stg2;

UPDATE practice_layoff_stg2
SET company = replace(company, '&', '');

UPDATE practice_layoff_stg2
SET company = replace(company, '#', '');

-- fix same industry with different format
SELECT * 
FROM practice_layoff_stg2
WHERE industry LIKE '%Crypto%';

UPDATE practice_layoff_stg2
SET industry = 'Crypto'
WHERE industry LIKE '%Crypto%';

-- fix incorrect industry
SELECT *, ROW_NUMBER() OVER (PARTITION BY total_laid_off, percentage_laid_off, industry) as duplication_null
FROM practice_layoff_stg2
ORDER BY company;

SELECT *
FROM practice_layoff_stg2
WHERE company = '100 Thieves';

UPDATE practice_layoff_stg2
SET industry = 'Retail'
WHERE company = '100 Thieves'
AND total_laid_off = 12;

-- fix date format
SELECT `date`, str_to_date(`date`, '%m/%d/%Y')
FROM practice_layoff_stg2;

UPDATE practice_layoff_stg2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE practice_layoff_stg2
MODIFY COLUMN `date` DATE;

# Fix NULL or Empty values
-- replace empty values with null
SELECT *
FROM practice_layoff_stg2
WHERE industry = ''
OR total_laid_off = ''
OR percentage_laid_off = ''
OR stage = ''
OR country = ''
OR funds_raised_millions = '';

UPDATE practice_layoff_stg2
SET industry = NULL
WHERE industry = '';

-- fix Null values
SELECT *
FROM practice_layoff_stg2;

SELECT *
FROM practice_layoff_stg2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

-- Remove useless data with both null value in total_laid_off and percentage_laid_off
DELETE FROM practice_layoff_stg2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

# Remove useless columns - duplication
ALTER TABLE practice_layoff_stg2
DROP COLUMN duplication;

SELECT *
FROM practice_layoff_stg2;

-- final table 1: without all null values
DROP TABLE IF EXISTS final_table_without_null;

CREATE TABLE final_table_without_null
LIKE practice_layoff_stg2;

SELECT *
FROM practice_layoff_stg2
WHERE total_laid_off IS NOT NULL
AND percentage_laid_off IS NOT NULL
AND funds_raised_millions IS NOT NULL;

INSERT INTO final_table_without_null
SELECT *
FROM practice_layoff_stg2
WHERE total_laid_off IS NOT NULL
AND percentage_laid_off IS NOT NULL
AND funds_raised_millions IS NOT NULL;

SELECT *
FROM final_table_without_null;

-- final table 2: with null values
DROP TABLE IF EXISTS final_table_with_null;

CREATE TABLE final_table_with_null
LIKE practice_layoff_stg2;

INSERT INTO final_table_with_null
SELECT *
FROM practice_layoff_stg2;

SELECT *
FROM final_table_with_null;