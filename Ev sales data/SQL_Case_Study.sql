select distinct year(id_date) from dim_date;

/*1.	List the top 3 and bottom 3 makers for the fiscal years 2023 and 2024 
in terms of the number of 2-wheelers sold. 
*/

with fst_cte as(
select maker,
       sum(electric_vehicles_sold) as total_sold from sales_by_makers
where vehicle_category='2-Wheelers' 
and
(id_date between '2022-04-01' and '2023-03-31'
or '2023-04-01' and '2024-03-31')
group by maker
),
top3 as(
select maker,total_sold, rank()over(order by total_sold desc)as `Rank`
from fst_cte order by total_sold desc limit 3
)
select * from top3 ;

# For Bottom 3

with fst_cte as(
select maker,
       sum(electric_vehicles_sold) as total_sold from sales_by_makers
where vehicle_category='2-Wheelers' 
and
(id_date between '2022-04-01' and '2023-03-31'
or '2023-04-01' and '2024-03-31')
group by maker
),
bottom3 as(
select maker,total_sold,rank()over(order by total_sold) as `Rank`
from fst_cte order by total_sold limit 3
)
select * from bottom3;

-- 2.Find the overall penetration rate in India for 2023 and 2022 

with fst_cte as(
select year(id_date) as year,
sum(electric_vehicles_sold) as Total_Evs,
sum(total_vehicles_sold)  as Total_Vehicles from sales_by_states
where id_date between '2022-01-01' AND '2023-12-31'
group by year(id_date) 
)
select year, Total_Evs, Total_Vehicles, 
Total_Evs/Total_Vehicles*100 as Penetration_Rate
from fst_cte;

-- 3.Identify the top 5 states with the highest penetration rate in 2-wheeler and 4-wheeler EV sales in FY 2024. 

/*
-- Step 1: Aggregate the EV sales and total vehicle sales for FY 2024
-- Step 2: Calculate the penetration rate and rank the states
-- Step 3: Select the top 5 states with the highest penetration rate for each category
*/

with fst_cte as(
select state,vehicle_category, 
       sum(electric_vehicles_sold) as Total_Evs,
       sum(total_vehicles_sold)  as Total_vehicles
       from sales_by_states
       where id_date between  '2023-04-01' AND '2024-03-31'
       group by state,vehicle_category
),
2nd_cte as(
select state,vehicle_category,
	   Total_Evs,Total_vehicles,
	   Total_Evs/Total_vehicles*100 as Penetration_Rate,
       row_number()over(partition by vehicle_category  order by  Total_Evs/Total_vehicles*100 desc) as Ranks
       from fst_cte
)
select state,
       vehicle_category,
       Penetration_Rate  from 2nd_cte 
       where Ranks<=5;



-- 4.	List the top 5 states having highest number of EVs sold in 2023

select state,sum(electric_vehicles_sold) as Total_EVS_Sold from sales_by_states 
where id_date between '2023-01-01' and '2023-12-31'
group by state 
order by Total_EVS_Sold desc limit 5;

-- 5.	List the states with negative penetration (decline) in EV sales from 2022 to 2024? 

 SELECT state,
       (SUM(CASE WHEN dim_date.fiscal_year = 2022 THEN sales_by_states.electric_vehicles_sold ELSE 0 END) / 
        SUM(CASE WHEN dim_date.fiscal_year = 2022 THEN sales_by_states.total_vehicles_sold ELSE 0 END)) * 100 AS penetration_rate_2022,
       (SUM(CASE WHEN dim_date.fiscal_year = 2024 THEN sales_by_states.electric_vehicles_sold ELSE 0 END) / 
        SUM(CASE WHEN dim_date.fiscal_year = 2024 THEN sales_by_states.total_vehicles_sold ELSE 0 END)) * 100 AS penetration_rate_2024,
       ((SUM(CASE WHEN dim_date.fiscal_year = 2024 THEN sales_by_states.electric_vehicles_sold ELSE 0 END) / 
         SUM(CASE WHEN dim_date.fiscal_year = 2024 THEN sales_by_states.total_vehicles_sold ELSE 0 END)) -
        (SUM(CASE WHEN dim_date.fiscal_year = 2022 THEN sales_by_states.electric_vehicles_sold ELSE 0 END) / 
         SUM(CASE WHEN dim_date.fiscal_year = 2022 THEN sales_by_states.total_vehicles_sold ELSE 0 END))) * 100 AS penetration_rate_change
FROM sales_by_states
JOIN dim_date ON sales_by_states.id_date = dim_date.id_date
WHERE dim_date.fiscal_year IN (2022, 2024)
GROUP BY state;


-- 6.	Which are the Top 5 EV makers in India?

select maker,
sum(electric_vehicles_sold) as Total_Evs 
from sales_by_makers
group by maker order by sum(electric_vehicles_sold)
desc limit 5;

-- 7.	How many EV makers sell 4-wheelers in India?

select count(distinct maker) as 4_wheeler_EV_Makers from sales_by_makers where 
vehicle_category='4-Wheelers';

-- 8.What is ratio of 2-wheeler makers to 4-wheeler makers?

select (select count(distinct maker) from sales_by_makers where vehicle_category='2-Wheelers' ) as 2_Wheeler_maker,
(select count(distinct maker) from sales_by_makers where vehicle_category="4-Wheelers") as 4_Wheeler_maker,
concat((select count(distinct maker) from sales_by_makers where vehicle_category='2-Wheelers'),       
         " : ",
	   (select count(distinct maker) from sales_by_makers where vehicle_category="4-Wheelers")) as RATIO;

 
 
-- 9.	What are the quarterly trends based on sales volume for the top 5 EV makers (4-wheelers) from 2022 to 2024? 
 WITH Top5Makers AS (
    SELECT maker
    FROM sales_by_makers
    JOIN dim_date 
        ON sales_by_makers.id_date = dim_date.id_date
    WHERE dim_date.fiscal_year BETWEEN 2022 AND 2024
    AND sales_by_makers.vehicle_category = '4-Wheelers'
    GROUP BY maker
    ORDER BY SUM(sales_by_makers.electric_vehicles_sold) DESC
    LIMIT 5
),
QuarterlySales AS (
    SELECT DISTINCT dim_date.fiscal_year, 
           dim_date.quarter, 
           sales_by_makers.maker, 
           SUM(sales_by_makers.electric_vehicles_sold) AS sales_volume
    FROM sales_by_makers
    JOIN dim_date 
        ON sales_by_makers.id_date = dim_date.id_date
    WHERE dim_date.fiscal_year BETWEEN 2022 AND 2024
    AND sales_by_makers.vehicle_category = '4-Wheelers'
    GROUP BY dim_date.fiscal_year, 
             dim_date.quarter, 
             sales_by_makers.maker
)
SELECT QuarterlySales.fiscal_year, 
       QuarterlySales.quarter, 
       QuarterlySales.maker, 
       QuarterlySales.sales_volume
FROM QuarterlySales
JOIN Top5Makers 
    ON QuarterlySales.maker = Top5Makers.maker
ORDER BY QuarterlySales.fiscal_year, 
         QuarterlySales.quarter, 
         QuarterlySales.sales_volume DESC;
 
 -- 10.	How do the EV sales and penetration rates in Maharashtra compare to Tamil Nadu for 2024? 
 
 select state,
		sum(electric_vehicles_sold) AS EVS,
        sum(total_vehicles_sold) as Total_Vehicle,
        sum(electric_vehicles_sold)/ sum(total_vehicles_sold)*100 as Penetration_Rate
        from sales_by_states
        where state in ('Maharashtra', 'Tamil Nadu') 
        AND id_date BETWEEN '2024-01-01' AND '2024-12-31'
        group by state order by Penetration_Rate;
        
        
-- 11 List down the compounded annual growth rate (CAGR) in 4-wheeler units for the top 5 makers from 2022 to 2024. 


create view total4_sold as (
select fiscal_year,sum(total_vehicles_sold) as total_sold 
from sales_by_states
join dim_date 
on sales_by_states.id_date=dim_date.id_date
where vehicle_category='4-Wheelers' 
group by fiscal_year);

SELECT em.maker,
        round(POWER((select total_sold from total4_sold where fiscal_year=2024) / 
        (select total_sold from total4_sold where fiscal_year=2022),1.0 / (2024-2022)) - 1,3)
        as CAGR_4_wheeler
from sales_by_makers as em
join dim_date as dd
 on em.id_date = dd.id_date
join total4_sold as ts
 on dd.fiscal_year = ts.fiscal_year
where dd.fiscal_year 
in(2022,2023,2024)
group by em.maker
order by CAGR_4_wheeler desc
limit 5;
        

       
-- 12.	List down the top 10 states that had the highest compounded annual growth rate (CAGR) 
--  from 2022 to 2024 in total vehicles sold. 
with 1st_cte as(
        select state,
	   sum(case when year(id_date) = 2022 then total_vehicles_sold else 0 end) as 2022_sales,
	   sum(case when year(id_date) = 2024 then total_vehicles_sold else 0 end) as 2024_sales
       from sales_by_states
       where 
       id_date between '2022-01-01' and '2024-12-31'
       group by state
)
select  state,
       round(power(2024_sales/2022_sales,1.0/3)-1,2) as CAGR
        from 1st_cte
	   group by state order by CAGR desc limit 10;
       
       
-- 13.	What are the peak and low season months for EV sales based on the data from 2022 to 2024? 
-- Step 1: Aggregate the sales data by month
-- Step 2: Find the peak season month (highest sales)
-- Step 3: Find the low season month (lowest sales)
-- Step 4: Combine the results

with 1st_cte as (
   select date_format(id_date,'%Y-%m') as Months,
		   sum(electric_vehicles_sold) as Total_EVS
           from sales_by_states
           where id_date between '2022-01-01' and '2024-12-31'
           group by Months
),
2nd_cte as( #highest_Sales
select Months,
       Total_EVS
       from 1st_cte
       group by Months order by Total_EVS desc limit 1
),
3rd_cte as(
select Months,
       Total_EVS
       from 1st_cte
       group by Months order by Total_EVS asc limit 1
)
select * from 2nd_cte union all select * from 3rd_cte;  

-- 14.	Estimate the revenue growth rate of 4-wheeler and 2-wheelers EVs in India for 2022 vs 2024 and 
-- 2023 vs 2024, assuming an average unit price. 
#Calculate Total Electric Vehicles Sold for Each Fiscal Year

with EV_Sales2 as (
select s.vehicle_category,d.fiscal_year,sum(s.electric_vehicles_sold) as Total_EVS_Sold
from sales_by_states as s  
join dim_date as d on 
s.id_date=d.id_date 
where fiscal_year in ('2022','2023','2024')
group by s.vehicle_category,d.fiscal_year),
# Step 2: Calculate Revenue for Each Fiscal Year
Revenue_summery as(
select vehicle_category,fiscal_year,Total_EVS_Sold,
case 
    when vehicle_category='2-Wheelers' then Total_EVs_Sold * 85000  # avg_prise for 2w = 85000
    when vehicle_category='4-Wheelers'then Total_EVs_Sold * 1500000  # avg_prise for 4w = 1500000
end as Revenue
from EV_Sales2)

select vehicle_category, 'CAGR_2022_VS_2024' AS period, 
round(
	power(
    (MAX(CASE WHEN fiscal_year = '2024' THEN Revenue END) / 
	MAX(CASE WHEN fiscal_year = '2022' THEN Revenue END)), (1.0 / 2.0)) - 1,3) AS CAGR
from Revenue_summery
where fiscal_year in ('2022','2024')
group by vehicle_category

UNION ALL

select vehicle_category, 
	  'CAGR_2023_VS_2024' AS period, 
round(
	power(
    (MAX(CASE WHEN fiscal_year = '2024' THEN Revenue END) / 
	MAX(CASE WHEN fiscal_year = '2023' THEN Revenue END)), (1.0 / 2.0)) - 1,3) AS CAGR
from Revenue_summery
where fiscal_year in ('2023','2024')
group by vehicle_category;






 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

