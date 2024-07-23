SELECT * FROM public.stolen_vehicle
ORDER BY vehicle_id ASC LIMIT 100


-- explorative analysis with postgres
-- the total number of vehicle stolen 

select vehicle_id , count(*) from  stolen_vehicle
	Group by vehicle_id ;

-- totalnumber of vehicel stolen
select count(*) from stolen_vehicle;

--What is the distribution of stolen vehicles by year?
select 
	extract(year from date_stolen) as year,
	count(*)
from
stolen_vehicle
	group by year
	order by count(*) desc;

--What is the average number of vehicles stolen per month?
with avearge_cte as(
select
	extract(month from date_stolen)as months,
	count(*) as counts
	
from
	stolen_vehicle
group by months
order by count(*) desc
	)
select avg(avearge_cte.counts) from avearge_cte;

--- month with the higest stolen vehicle?
select
	to_char(date_stolen,'Month') as months,
	count(*) as counts
	
from
	stolen_vehicle
group by months
order by count(*) desc

-- day with the higest stolen vehicle
select
	to_char(date_stolen,'Day') as Days,
	count(*) as counts
	
from
	stolen_vehicle
group by Days
order by count(*) desc

--Which types of vehicles are most frequently stolen?
select vehicle_type,
	count(*) as counts
from 
	stolen_vehicle
group by vehicle_type
	order by count(*) desc;

--What is the distribution of stolen vehicles by type?
select vehicle_type,
	count(*) as counts
from 
	stolen_vehicle
group by vehicle_type
	order by vehicle_type  desc;

--Are certain types of vehicles more likely to be stolen in specific regions?
with vehicle_cte as(
select *
from 
	stolen_vehicle s
join 
	location l
on s.location_id = l.location_id)
select 
	vehicle_cte.vehicle_type,
	vehicle_cte.region,
	count(*)
from vehicle_cte
	group by vehicle_cte.vehicle_type,vehicle_cte.region
	order by count(*) desc

--Make and Model Year Analysis:
-- Which car makes are most frequently stolen?	
select make_name,
	count(*)
from
	make_car
group by make_name
order by count(*) desc

-- What is the distribution of stolen vehicles by model year?
select 
	model_year,
	vehicle_type,
	count(*)
from 
	stolen_vehicle
	group by model_year,vehicle_type
order by count(*) desc

-- Are there any trends in the model years of stolen vehicles?
	select 
	model_year,
	vehicle_type,
	count(*)
from 
	stolen_vehicle
	group by model_year,vehicle_type
order by count(*) desc, model_year desc

-- total number of vehicle stoeln in each year
	select distinct(model_year) as model from stolen_vehicle
	order by  model desc
SELECT
    sum(case when model_year = 2021 then 1 else 0 end) as year_2021,
    sum(case when model_year = 2022 then 1 else 0 end) as year_2022,
    sum(case when model_year = 2020 then 1 else 0 end) as year_2020,
    sum(case when model_year = 2019 then 1 else 0 end) as year_2019,
    sum(case when model_year = 2018 then 1 else 0 end) as year_2018,
    sum(case when model_year = 2017 then 1 else 0 end) as year_2017,
    sum(case when model_year = 2016 then 1 else 0 end) as year_2016,
    sum(case when model_year = 2015 then 1 else 0 end) as year_2015,
    sum(case when model_year = 2014 then 1 else 0 end) as year_2014,
    sum(case when model_year = 2013 then 1 else 0 end) as year_2013
FROM stolen_vehicle;
	
--Which regions have the highest number of stolen vehicles
with vehicle_cte as(
select *
from 
	stolen_vehicle s
join 
	location l
on s.location_id = l.location_id)
select 
	
	vehicle_cte.region,
	count(*)
from vehicle_cte
	group by vehicle_cte.vehicle_type,vehicle_cte.region
	order by count(*) desc
--What is the distribution of stolen vehicles by country?
with vehicle_cte as(
select *
from 
	stolen_vehicle s
join 
	location l
on s.location_id = l.location_id)
select 
	vehicle_cte.country,
	vehicle_cte.vehicle_type,
	count(*)
from vehicle_cte
	group by vehicle_cte.country,vehicle_cte.vehicle_type
	order by count(*) desc



-- How does the population density of a location correlate with the number of stolen vehicles?
with vehicle_cte as(
select *
from 
	stolen_vehicle s
join 
	location l
on s.location_id = l.location_id)
select 
	vehicle_cte.density,
	vehicle_cte.vehicle_type,
	count(*)
from vehicle_cte
	group by vehicle_cte.vehicle_type,vehicle_cte.density
	order by count(*) desc,vehicle_cte.density desc

--Color Analysis:
--What are the most common colors of stolen vehicles?
select
	color,
	count(*)
from 
	stolen_vehicle
group by  color
	order by count(*) desc
-- Are certain colors of vehicles more likely to be stolen in specific regions?
WITH vehicle_cte AS (
  SELECT *
  FROM stolen_vehicle s
  JOIN location l ON s.location_id = l.location_id
)
SELECT
  vehicle_cte.color,
  vehicle_cte.region,
  COUNT(*) AS count
FROM vehicle_cte
GROUP BY vehicle_cte.region, vehicle_cte.color
ORDER BY count DESC;

--Date and Time Analysis:
--Are there certain months or seasons when vehicle thefts are more common?

WITH month_cte AS (
  SELECT
    TO_CHAR(date_stolen, 'month') AS months,
    vehicle_type,
    COUNT(*) AS count
  FROM stolen_vehicle
  GROUP BY months, vehicle_type
  ORDER BY count DESC
)
SELECT * INTO months_table
FROM month_cte;	
SELECT
  SUM(CASE WHEN months = 'january' THEN 1 ELSE 0 END) AS january,
  SUM(CASE WHEN months = 'february' THEN 1 ELSE 0 END) AS february,
  SUM(CASE WHEN months = 'march' THEN 1 ELSE 0 END) AS march,
  SUM(CASE WHEN months = 'april' THEN 1 ELSE 0 END) AS april,
  SUM(CASE WHEN months = 'may' THEN 1 ELSE 0 END) AS may,
  SUM(CASE WHEN months = 'june' THEN 1 ELSE 0 END) AS june,
  SUM(CASE WHEN months = 'july' THEN 1 ELSE 0 END) AS july,
  SUM(CASE WHEN months = 'august' THEN 1 ELSE 0 END) AS august,
  SUM(CASE WHEN months = 'september' THEN 1 ELSE 0 END) AS september,
  SUM(CASE WHEN months = 'october' THEN 1 ELSE 0 END) AS october,
  SUM(CASE WHEN months = 'november' THEN 1 ELSE 0 END) AS november,
  SUM(CASE WHEN months = 'december' THEN 1 ELSE 0 END) AS december
FROM months_table;

--What combinations of vehicle type and make are most commonly stolen?
select
	make_name, 
	vehicle_type,
	count(*)
from make_car ms
	join
	stolen_vehicle s
on
	ms.make_id=s.make_id
	group by make_name, vehicle_type 
	order by count(*)
--Are there any specific vehicle types and colors that are more likely to be stolen
select
	vehicle_type,
	color,
	count(*)
from
	stolen_vehicle
	group by color,vehicle_type
	order by count(*) desc

select * from months_table
select * from stolen_vehicle
select * from make_car
select * from location;
