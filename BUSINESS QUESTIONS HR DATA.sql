-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SELECT 
    gender, COUNT(gender) AS count
FROM
    hr
where termdate is null
GROUP BY gender
ORDER BY count DESC;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT 
    race, COUNT(race) AS count
FROM
    hr
where termdate is null
GROUP BY race
ORDER BY count desc;

-- 3. What is the age distribution of employees in the company?
select min(age) as youngest, max(age) as oldest from hr
where age > 0 and termdate is null; # using where condition to eleminate 0 as we have replaced null values with 0.

# We will group into age group and get the count
SELECT 
case when age >=18 and age <=24 then '18-24'
 when age >=25 and age <=34 then '25-34'
 when age >=35 and age <=44 then '35-44'
  when age >=45 and age <=54 then '45-54'
  when age >=55 and age <=64 then '55-64'
  else '65+'
  end as age_group,
  count(*) as count from hr
  where age>=28 and termdate is null
  group by age_group
  order by age_group;
  
# Gedner wise count for each group
SELECT
case when age >=18 and age <=24 then '18-24'
 when age >=25 and age <=34 then '25-34'
 when age >=35 and age <=44 then '35-44'
  when age >=45 and age <=54 then '45-54'
  when age >=55 and age <=64 then '55-64'
  else '65+'
  end as age_group,
  gender,
  count(*) as count from hr
  where age>=28 and termdate is null
  group by age_group, gender
  order by age_group, gender;


# let's find quartile distribution of age

WITH Ranked AS (
    SELECT
        age,
        PERCENT_RANK() OVER (ORDER BY age) AS percentile_rank
    FROM
        hr
	where age > 0
)
SELECT
    MAX(CASE WHEN percentile_rank <= 0.25 THEN age END) AS Q1,
    MAX(CASE WHEN percentile_rank <= 0.50 THEN age END) AS Q2,
    MAX(CASE WHEN percentile_rank <= 0.75 THEN age END) AS Q3,
    MAX(CASE WHEN percentile_rank <= 0.90 THEN age END) as '90th'
FROM
    Ranked;


-- 4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) as count
from hr
where age >=18 and termdate is null
group by location;


-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
    ROUND(AVG((DATEDIFF(termdate, hire_date)) / 365),
            2) AS avg_length_emp
FROM
    hr
WHERE
    termdate IS NOT NULL and termdate <= CURDATE();
    


-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, jobtitle, count(*) from hr
where age >= 18 and termdate is null
group by department, gender, jobtitle
order by department;

# Gender distribution across department

SELECT department, gender, count(*) from hr
where age >= 18 and termdate is null
group by department, gender
order by department;


-- 7. What is the distribution of job titles across the company?
select jobtitle, count(*) as count from hr
where age >= 18 and termdate is null
group by jobtitle
order by count desc;


-- 8. Which department has the highest turnover rate? We will be using subquery here
select department,
	total_count,
    terminated_count,
    terminated_count/total_count as termination_rate
FROM(
	select department,
    count(*) as total_count,
    sum(case when termdate is not null and termdate <= curdate() then 1 else 0 end) as terminated_count
    FROM hr
    WHERE age>= 18
    GROUP BY department
    ) as subquery
ORDER BY termination_rate desc;


-- 9. What is the distribution of employees across locations by city and state?
select location, state, city, count(*) as count from hr
where age >= 18 and termdate is null
group by location, state, city
order by location, state, city;

# just by state
select state, count(*) as count from hr
where age >=18 and termdate is null
group by state
order by count desc;


-- 10. How has the company's employee count changed over time based on hire and term dates? We will use subquery
select
	year,
    hires,
    termination,
    hires - termination as net_change,
    round((hires - termination)/hires * 100, 2) as net_change_percent
from (
	Select
		year(hire_date) as year,
        count(*) as hires,
        sum(case when termdate is not null and termdate <= curdate() then 1 else 0 end) as termination
	from hr
    WHERE age >= 18 and year(hire_date) is not null
    group by year(hire_date)
    ) as sub
ORDER BY year asc;


-- 11. What is the tenure distribution for each department?
select department, round(avg(datediff(termdate, hire_date)/365),2) as avg_tenure
from hr
where age >= 18 and termdate is not null and termdate <= curdate()
group by department
order by avg_tenure desc;




