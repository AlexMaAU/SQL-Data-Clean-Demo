SQL Data Cleansing Process:

- Preliminary examination of imported data revealed several issues:
  1. Null values present in the total_laid_off and Percentage_laid_off columns.
  2. Some data exhibits duplication.
  3. Potential duplication of company names across different countries.
  4. Leading whitespace detected in some values of the Company and Country columns, necessitating trimming.
  5. Values in the Industry column require formatting as the original data employs various patterns to represent the same information.

- Copying the raw data to a newly created layoff_staging table to avoid direct modification of the original dataset.

- Identifying and removing duplicate records from the table.

- Trimming leading and trailing whitespace from the Company and Country columns.

- Standardizing all values in the Industry column to use a consistent pattern for representing the same information.

- Standardizing data with empty values by replacing them with null.

- Converting the date column format from M/D/Y to Y-M-D.

- Attempting to address null value data by inheriting values from related records. If null values cannot be resolved, they will be removed from the table.
