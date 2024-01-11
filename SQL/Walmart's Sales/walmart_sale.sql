-- Create database
create database if not exists salesDataWalmart;

use salesDataWalmart;

-- Create table
create table if not exists sales (
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null, 
    city varchar (30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null, 
    unit_price decimal(10,2) not null,
    quantity int not null, 
    VAT float (6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null, 
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
    );
    
-- Adding a column named time_of_day to show sales in the Morning, Afternoon, and Evening. Help answer which part of the day most sales were made. 
-- time_of_day

select 
	time, 
	(case
		when time between "00:00:00" and "12:00:00" then "Morning"
        when time between "120:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
	) as time_of_date
from sales;

alter table sales add column time_of_day varchar(20);

select *
from sales;

update sales
set time_of_day = (case
		when time between "00:00:00" and "12:00:00" then "Morning"
        when time between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end);
    
select time, time_of_day
from sales;

-- Adding a column named day_name to show which extracted days of the week given transactions took place. Help answer which week of the day each branch is busiest. 
-- day_name

select *
from sales;

select 
	date,
    dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10);

update sales 

set day_name = dayname(date);

select *
from sales;

-- Adding a column named month_name to show which extracted months of the year given transactions took place. Help answer which month of the year has the most sales and profit. 
-- month_name

select 
	date,
    monthname(date) as month
from sales;

alter table sales add column month_name varchar(10);

update sales

set month_name = monthname(date);

select *
from sales;

------ Questions to Answer ------

-- How many unique cities does the data have?

select count(distinct city)
from sales;

-- In which city is each branch?
-- How many branches are in each cities? 

select 
	distinct city,
    branch
from sales;

select
city,
branch, 
count(branch) as count_branches
from sales
group by city, branch
order by count_branches desc ;

-- How many unique product lines does the data have? 

select * 
from sales;

select 
	distinct product_line
from sales;

select 
	count(distinct product_line)
from sales;

-- What is the most common payment method?

select 
	*
from sales;

select 
	payment
from sales;

select 
	distinct payment
from sales;

select 
	distinct payment,
    count(payment) count_payment
from sales
group by payment
order by count_payment desc;

-- What is the most selling product line?

select 
	*
from sales;

select 
	product_line,
    count(product_line) count_product_line
from sales
group by product_line
order by count_product_line desc;

-- What is the total revenue by month?

select 
	*
from sales;

select
	month_name as month,
    sum(total) as total_revenue
from sales
group by month
order by total_revenue desc;

-- What month had the largest COGS?

select
	*
from sales;

select 
	month_name as month,
    sum(cogs) as cogs
from sales
group by month
order by cogs desc;

-- What product line had the largest revenue?

select 
	*
from sales;

select 
	product_line,
    sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- Which city had the largest revenue?

select
	*
from sales;

select
	city,
    sum(total) as total_revenue
from sales
group by city
order by total_revenue desc;

select
	city,
    sum(total) as total_revenue
from sales
group by city
order by total_revenue desc
limit 1;

select city, total_revenue,
rank() over( order by total_revenue desc) as rank_no
from
(select
	city,
    sum(total) as total_revenue
from sales
group by city) city;

-- Which product line had the largest revenue?

select
	product_line,
    sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

select
	product_line,
	total_revenue, 
    rank() over (order by total_revenue desc) as rank_no
from (
select
	product_line,
    sum(total) as total_revenue
from sales
group by product_line
)product;

-- What product line had the largest VAT?

select
	product_line,
    avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

select 
	product_line,
    avg_tax,
    rank() over(order by avg_tax desc) as rank_no
from (
select
	product_line,
     avg(VAT) as avg_tax
from sales
group by product_line
)vat;

-- Which branch sold more products than average product sold?

select
	branch,
    sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

select 
	branch,
    qty,
    rank() over(order by qty desc) as rank_no
from (
select
	branch,
    sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales)
) result;

-- What is the most common product line by gender?

select
	gender,
    product_line,
    count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- What is the average rating of each product line?

select 
	*
from sales;

select
	product_line,
    avg(rating) as avg_rating
from sales
group by product_line
order by avg_rating desc;

-- Number of sales made in each time of the day per weekday

select
	*
from sales;

select 
	time_of_day,
    count(*) as total_sales
from sales
where day_name = "Monday"
group by time_of_day
order by total_sales desc;

-- Which of the customer types brings the most revenue?

select
	*
from sales;

select 
	customer_type,
    sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax percent/VAT (Value Added Tax)?

select 
	*
from sales;

select 
	city,
    avg(VAT) as VAT
from sales
group by city
order by VAT desc;

-- Which customer type pays the most in VAT?

select 
	customer_type,
    avg(VAT) as VAT
from sales
group by customer_type
order by VAT desc;

-- How many unique customer types does the data have?

select
	distinct customer_type
from sales;

-- How many unique payment methods does the data have?

select
	distinct payment
from sales;

-- Which customer type buys the most?

select
	 customer_type,
     count(*) as customer_count
from sales
group by customer_type
order by  customer_count desc;

-- What is the gender of most of the customers?

select 
	gender,
    count(*) as gender_count
from sales
group by gender
order by gender_count desc;

-- What is the gender distribution per branch?

select 
	branch,
	gender,
    count(*) as gender_count
from sales
group by branch, gender
order by branch;

-- Which time of the day do customers give most ratings?

select
	time_of_day,
    avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

-- Wihich time of the day do customers give most ratings per branch?

select
	branch,
	time_of_day,
    avg(rating) as avg_rating
from sales
group by branch, time_of_day;

-- Which day of the week has the best avg ratings?

select
	day_name,
    avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- Which day of the week has the best average ratings per branch?

select
	day_name,
    avg(rating) as avg_rating
from sales
where branch = "A"
group by day_name
order by avg_rating desc;
























    

    























