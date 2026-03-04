select * 
from layoffs;

-- checking duplicates
SELECT *, COUNT(*) 
FROM layoffs
GROUP BY company,location,industry, total_laid_off,percentage_laid_off , `date`, stage, country, funds_raised_millions
HAVING COUNT(*) > 1;

-- Removing duplicates
CREATE TABLE layoffs_2 AS
SELECT DISTINCT * FROM layoffs;

select *
from layoffs_2;

-- checking duplicates
SELECT *, COUNT(*) 
FROM layoffs_2
GROUP BY company,location,industry, total_laid_off,percentage_laid_off , `date`, stage, country, funds_raised_millions
HAVING COUNT(*) > 1;

-- Done removing duplicates

-- Standardizing
-- company
select distinct company
from layoffs_2
order by 1;

select distinct company
from layoffs_2
where company <> trim(company)
order by 1;

update layoffs_2
set company = trim(company);

-- location

select distinct location
from layoffs_2
order by 1;

select distinct location
from layoffs_2
where location <> trim(location)
order by 1;

-- industry

select distinct industry
from layoffs_2
order by 1;

select distinct industry
from layoffs_2
where industry <> trim(industry)
order by 1;

update layoffs_2
set industry = null
where industry = '';

update layoffs_2
set industry = "Crypto"
where industry like "Crypto%";

-- stage

select distinct stage
from layoffs_2
order by 1;

select distinct stage
from layoffs_2
where stage <> trim(stage)
order by 1;

-- country
select distinct country
from layoffs_2
order by 1;

update layoffs_2
set country = "United States"
where country like "United States%";

select distinct stage
from layoffs_2
where stage <> trim(stage)
order by 1;

-- handing nulls

select * 
from layoffs_2;

select t1.*, t2.industry
from layoffs_2 t1
join layoffs_2 t2
on t1.company = t2.company
where t1.location = t2.location and t1.country = t2.country and t1.industry is null;

update layoffs_2 t1
join layoffs_2 t2
on t1.company = t2.company and
t1.location = t2.location and 
t1.country = t2.country
set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null;

delete
from layoffs_2
where industry is null;

select * 
from layoffs_2;

-- total laid off and %

delete
from layoffs_2
where total_laid_off is null and percentage_laid_off is null;

select * 
from layoffs_2
where total_laid_off is null or percentage_laid_off is null;

select * from layoffs_2;











