## DATA CLEANING AND PRE PROCESSING ##

SELECT 
    *
FROM
    hr;

ALTER TABLE hr
CHANGE COLUMN id emp_id varchar(40) null,
change column location_city city varchar(20),
change column location_state state varchar(20);

set sql_safe_updates = 0;

# Unifying birthdate column and changing data type to date from text
UPDATE hr 
SET 
    birthdate = CASE
        WHEN
            birthdate LIKE '%/%'
        THEN
            DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'),
                    '%Y-%m-%d')
        WHEN
            birthdate LIKE '%-%'
        THEN
            DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'),
                    '%Y-%m-%d')
        ELSE NULL
    END;

alter table hr
modify column birthdate date;


# Unifying hire_date & termdate column and changing data type to date from text

# this code will convert 0 to null in hire_date column
update hr
set hire_date = null
where hire_date = 0;

# Unifying hire_date & termdate column and changing data type to date from text
UPDATE HR 
SET 
    hire_date = CASE
        WHEN
            hire_date LIKE '%/%'
        THEN
            DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'),
                    '%Y-%m-%d')
        WHEN
            hire_date LIKE '%-%'
        THEN
            DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'),
                    '%Y-%m-%d')
        ELSE null
    END;
    
ALTER TABLE HR
MODIFY COLUMN hire_date date;

# Modifying term date

UPDATE hr
set termdate = null
where termdate = '' or termdate is null;

UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
where termdate is not null;

ALTER TABLE hr
MODIFY COLUMN termdate date;

select termdate from hr;

describe hr;

# Add age column to the database
ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT 
    MIN(age) AS youngest, MAX(age) AS oldest
FROM
    hr;
    
# set null values in age column to 0
UPDATE hr
SET age = 0
where age is null;

select count(age) from hr where age = 0;


