select * 
from layoffs_2;

-- Date range
select min(date), max(date)
from layoffs_2;
-- March 2020 to March 2023

-- Companies having the highest laid offs
select company, sum(coalesce(total_laid_off,0)) as laid_off
from layoffs_2
group by company
order by laid_off desc;
-- Amazon is the highest.

-- Industries having the highest laid offs
select industry, sum(coalesce(total_laid_off,0)) as laid_off
from layoffs_2
group by industry
order by laid_off desc;
-- Consumer is the highest.

-- Locations having the highest laid offs
select location, sum(coalesce(total_laid_off,0)) as laid_off
from layoffs_2
group by location
order by laid_off desc;
-- 'SF Bay Area' is the highest with a significantly more than the second highest place, Seattle.

-- Stages having the highest laid offs
select stage, sum(coalesce(total_laid_off,0)) as laid_off
from layoffs_2
group by stage
order by laid_off desc;
-- 'Post-IPO' stage is the highest.

-- Ranking the highest laid offs years
select year(date), sum(coalesce(total_laid_off,0)) as laid_off, dense_rank() over(order by laid_off desc) as ranking
from layoffs_2
group by year(date)
order by laid_off desc;
-- 2022 is the highest year.

-- Time series
select date_format(date, '%m-%Y') as month_year, sum(coalesce(total_laid_off,0)) as laid_off
from layoffs_2
group by date_format(date, '%m-%Y')
order by 1;

-- rolling total per Year
select date_format(date, '%m-%Y') as month_year, sum(coalesce(total_laid_off,0)) as laid_off,
sum(sum(coalesce(total_laid_off,0))) over(
partition by year(date)
order by year(date), month(date)
rows between unbounded preceding and current row) as rolling_total
from layoffs_2
group by year(date), month(date)
order by year(date), month(date);

-- per company per year top 5 laid off

with t1 as(
select company, year(date) as year, sum(total_laid_off) as laid_off,
dense_rank() over(
partition by year
order by sum(total_laid_off) desc)as ranking
from layoffs_2
group by company, year
order by ranking)
select *
from t1
where ranking <=5
order by year;



























