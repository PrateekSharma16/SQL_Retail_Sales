-- SQL Retail Analysis --Project P1--
create database sql_project_p2;

-- Create table retail sales --
Drop table if exists reatail_sales;

create table retail_sales(
	transactions_id	int primary key,
	sale_date date,
	sale_time time,
	customer_id	int,
	gender varchar(15),
	age	int,
	category varchar(30),	
	quantiy	int,
	price_per_unit float,	
	cogs float,
	total_sale float
	);

	select * from  retail_sales ;

	select count(*) from retail_sales;

	-- Data Cleaning--
	select * from retail_sales
	where 
		transactions_id is null
		or
		sale_date is null
		or 
		sale_time is null
		or
		customer_id is null
		or
		gender is null
		or
		age is null
		or
		category is null
		or
		quantiy is null
		or
		price_per_unit is null
		or
		cogs is null
		or
		total_sale is null;
---
delete from retail_sales
where 
quantiy is null
		or
		price_per_unit is null
		or
		cogs is null
		or
		total_sale is null;

-- 
select count(*) from retail_sales;
--Data Exloration --
-- how many sales do we have--
select count(*) as total_sales from retail_sales;

-- how many unique customer do we have --
select count(distinct customer_id) as total_Customer from retail_sales;

-- how many types of categoary do we have?--
select count(distinct category) as total_category from retail_sales;
select distinct category from retail_sales;

-- Data Analysis or Bussiness key answers --

-- Q1- Retrive all columns for sales made on '2022-11-05'
select * from retail_sales 
where sale_date='2022-11-05';

-- Q2- Retrive all the transaction where the category is clothing and the quantity sold is more than 4 in the month of November 2022.
select * from retail_sales
where category='clothing' and 
TO_CHAR(sale_date,'YYYY-MM')='2022-11'
and 
quantiy>=2;

--Q3- Write a sql query to find total sales for each category
select *from retail_sales;

select category,sum(total_sale) as net_sale,count(total_Sale)as toal_order from retail_sales
group by category;

--Q4-Write a query to find average age of customer who purchased item from Beauty category.
select round(avg(age),2) as avg_customer_age from retail_sales
where category = 'Beauty';

--Q5 Write a qury to find tranasction where the total sales is greater than 1000.
select transactions_id from retail_sales
where total_sale >1000;

--Q6- Write a query to find total number of transactions made by each gender for each category.
select count(transactions_id) as total_transaction,gender,category from retail_sales
group by gender, category
order by category;

--Q7-- Write a query to find average sale of each month and find out best selling month in each year.
select * from
(
select 
EXTRACT(year from sale_date) as year,
EXTRACT (month from sale_date) as month,
AVG(total_sale) as total_Sale,
RANK()OVER(Partition by EXTRACT( year from sale_date) order by avg(total_Sale) desc) as rank
from retail_sales
group by year,month
) as t1
where rank =1;

--Q8-- Write an SQL query the top 5 customers based on highest total_Sales
select customer_id,
sum(total_sale)
from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5;

--Q9--Write an query to find number of unique customer who purchased from each category.
select count(distinct customer_id) unique_customer, category from retail_sales
group by category;

--10 -- Write an SQL Query to each shift and number of orders (Example <12 , Afternoon between 12 and 17, Evening >17)
With hourly_Sale
as
(
select *,
CASE 
	When extract(Hour from sale_time)< 12 Then 'Morning'
	When extract(hour from sale_time) between 12 and 17 Then 'Afternoon'
	When extract(hour from sale_time) >17 Then 'Evening'
End as shift
from retail_sales
)
select shift,
count(transactions_id) as total_orders
from hourly_sale
group by shift;

--END OF PROJECT--