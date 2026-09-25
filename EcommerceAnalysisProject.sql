Create Database Ecommerce_analysis;
Use Ecommerce_analysis;

Create Table Customers (
customer_id varchar(50) Primary key,
customer_unique_id varchar(50) Not Null,
customer_zip_code_prefix int(10),
customer_city varchar(100),
customer_state char(10)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Create Table Products (
product_id varchar(50) Primary key,
product_category_name varchar(50) Not Null,
product_name_length int(10),
product_description_lenght int(10),
product_photos_qty int(10),
product_weight_gm int(100),
product_weight_category varchar(50),
product_length_cm int(10),
product_height_cm int(10),
product_width_cm int(10)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Create Table Orders (
Order_id varchar(50) Primary key,
customer_id varchar(50),
customer_city varchar(50),
customer_state varchar(50),
order_status varchar (20),
order_date Date,
order_time time,
order_year int,
order_month varchar(15),
order_day int,
order_day_name varchar(15),
order_hour int,
delivery_date date,
delivery_time time,
delivery_year int,
delivery_month varchar(15),
delivery_day int,
delivery_day_name varchar(15),
delivery_hour int,
delivery_days_taken int,
delivery_status varchar(32),
late_delivery_indicator varchar(32)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders1.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
enclosed by ''''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Order_id ,
customer_id ,
customer_city ,
customer_state ,
order_status,
@var_order_date ,
order_time ,
order_year ,
order_month ,
order_day ,
order_day_name ,
order_hour ,
@var_delivery_date ,
delivery_time ,
delivery_year ,
delivery_month ,
delivery_day ,
delivery_day_name ,
delivery_hour ,
@var_delivery_days_taken ,
delivery_status ,
late_delivery_indicator 
)
SET order_date = if(@var_order_date = '', Null , str_to_date(@var_order_date,'%d-%m-%Y')),
delivery_date = If(@var_delivery_date = '', NULL , str_to_date(@var_delivery_date,'%d-%m-%Y')),
delivery_days_taken = nullif(Trim(@var_delivery_days_taken), '');

Create Table Orders_item (
order_id varchar(50),
order_date date,
order_item_id int,
product_id varchar(50),
product_category_name varchar (50),
seller_id varchar(50),
shipping_limit_date date,
price decimal(10,2),
freight_value decimal(10,2),
total_revenue decimal(10,2),
freight_percentage decimal (5,4)
);

Alter table orders_item 
modify freight_percentage decimal(10,2);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders_item.csv'
INTO TABLE orders_item
FIELDS TERMINATED BY ','
enclosed by ''''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
order_id,
@var_order_date,
order_item_id,
product_id,
product_category_name,
seller_id,
@var_shipping_limit_date ,
price ,
freight_value,
total_revenue ,
freight_percentage
)
Set order_date = If(Trim(@var_order_date) = '#N/A' OR @var_order_date = '', NUll, str_to_date(@var_order_date,'%d-%m-%Y')),
shipping_limit_date =IF(Trim(@var_shipping_limit_date) = '#N/A' OR @var_shipping_limit_date = '', NULL, str_to_date(@var_shipping_limit_date,'%d-%m-%Y'));

Create table Sellers (
seller_id varchar(50) Primary key,
seller_zip_code_prefix int,
seller_city varchar(32),
seller_state varchar(20)
);

Alter Table sellers modify seller_city varchar(100);

Truncate Table Sellers;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sellers.csv'
INTO TABLE Sellers
character set latin1
FIELDS TERMINATED BY ','
enclosed by '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

Create table Order_payments (
order_id varchar(50) primary key,
payment_sequential int,
payment_type varchar(100),
paymnet_installments int,
payment_value decimal (10,2),
payment_types varchar (100),
payment_size_category varchar(100)
);

Alter table order_payments  drop primary key;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders_payments.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
enclosed by '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

create Table product_category(
product_category_name varchar (200),
product_category_name_english varchar (200)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category.csv'
INTO TABLE product_category
FIELDS TERMINATED BY ','
enclosed by '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;



-- Exploratory Analysis

Select * From customers;
Select * from order_payments;
Select * From orders;
Select * From orders_item;
Select * From product_category;
select * from products;
select * from sellers;

Select Count(*) From orders; -- TotalNumberofOrders
Select Count(*) From customers; -- TotalNumbersofcustomers

Select sum(payment_value) from order_payments; -- Totalrevenuegenerated

Select order_year as Year, order_month as month, sum(payment_value) -- revenuebymonthandyear
From orders o 
join order_payments op 
on o.order_id = op.order_id
Group by order_year, order_month
order by order_year, order_month;

Select customer_state as state, count(order_id) as total_orders  -- totalordersbystate
from orders
group by state
order by total_orders desc;

Select o.product_category_name as Category, pc.product_category_name_english as English_Name, sum(price) as total_price -- TopProductCategories
From orders_item o 
join product_category pc 
on o.product_category_name = pc.product_category_name
group by Category , English_Name
order by total_price desc; 

Select Avg(datediff(delivery_date,order_date)) As Average_Delivery_Days -- AverageDeilveryDaysTaken
From Orders
Where order_status = "Delivered";

Select * from orders;
Select order_day_name as WEEKDAYNAME , Count(order_id) As Total_Orders -- totalordersbydayname
From Orders
Group By WEEKDAYNAME
Order BY Total_orders Desc;

Select order_hour as HOUR, Count(order_id) as Total_orders -- totalordersaroundhours
From orders
group by Hour 
order by Total_orders Desc;

Select * From order_payments;

Select payment_type as Type, Count(order_id) As Total_Orders -- Totalordersbypaymenttype
From order_payments
Group by Type 
Order by Total_orders Desc;

Select * From orders_item;
Select product_category_name As category, Count(order_id) as total_orders -- totalordersbycategory
From orders_item
Group by category
order by total_orders desc;

Select * from orders;

Select Count(*) As total_late_deliveries -- totallatedeliveries
From orders
Where late_delivery_indicator = 'Late Delivery';

Select Sum(payment_value)/count(distinct order_id) as avg_order_value  -- avgordervalue
from order_payments;

Select * From orders_item;

Select oi.product_id As ID, oi.product_category_name as Product_name, pc.product_category_name_english as English_name, Sum(price) As Total_Price
From orders_item oi 
join product_category pc 
on oi.product_category_name = pc.product_category_name
Group by ID, Product_name, English_name
order by Total_price desc
Limit 10;                                 -- RevenueGeneratingTop10Products

SELECT 
oi.product_category_name,
SUM(price) AS revenue,
SUM(price) * 100 /
(SUM(SUM(price)) OVER()) AS revenue_share
FROM orders_item oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY oi.product_category_name
ORDER BY revenue DESC;                         -- RevenueContributionByCategoryName

Select * from Orders;

Select customer_id, count(o.order_id) as total_orders,
sum(payment_value) as life_time_value
From orders o 
join order_payments op 
on o.order_id = op.order_id
Group By customer_id 
Order by life_time_value desc;                  -- Lifetimeordersandvalue

Select Count(*) as total_count
From ( 
select customer_id 
From orders 
group by customer_id
Having count(order_id)>1
) as repeat_table;                              -- RepeatCustomers

Select * From Orders;

Select customer_state, Avg(DateDiff(delivery_date,order_date)) as avg_delivery_day
From orders 
Group by customer_state
Order by avg_delivery_day desc;                  -- Average Delivery Day for each state


Select * From orders_item;

Select pc.product_category_name, pc.product_category_name_english as english_name,
Avg(oi.freight_value) as avg_shipping_cost
from orders_item oi 
join product_category pc
on oi.product_category_name = pc.product_category_name
group by pc.product_category_name, pc.product_category_name_english
order by avg_shipping_cost desc;                 -- Avg Shipping Cost By Category


Select * From orders;

Select month, revenue, revenue - Lag(revenue) over (order by month) as growth 
From (
Select order_month as month, sum(payment_value) as revenue
from orders o 
join order_payments op
on o.order_id = op.order_id
Group by month
)t;                                              -- monthly growth rate


Select customer_id, Sum(payment_value) as revenue,
Case
when sum(payment_value) < 100 then 'Low Value'
When sum(payment_value) Between 100 And 500 Then 'Medium Value'
Else 'High Value'
end As customer_segment
From orders o
join order_payments op 
on o.order_id = op.order_id
group by customer_id;                            -- Customer Segmentation By Spending


Select order_month as month, p.product_category_name as category, count(o.order_id) as orders
From orders o 
join orders_item op 
on o.order_id = op.order_id
join products p 
on op.product_id = p.product_id
group by month, category;                        -- Product demand trend


Select customer_id,max(o.order_date) as last_purchase, count(o.order_id) as frequency, sum(payment_value) as monetary
from orders o 
join order_payments op 
on o.order_id = op.order_id
group by customer_id;                            -- Recency , Frequency, Monetary (RFM)


/*The Pareto Principle states:
80% of revenue often comes from 20% of customers or products. */

Select product_id, sum(price) as cost
from orders_item
group by product_id
order by cost desc;                              -- Revenue BY Product 

/*Customer Cohort Analysis
Cohort analysis groups customers by the month they first purchased.
This helps analyze customer retention over time.
Used heavily in:
SaaS companies
E-commerce businesses
subscription platforms*/

Select customer_id, 
min(order_date) as first_date_of_purchase
from orders
group by customer_id;

Select date_format(first_date_of_purchase,"%Y-%m") as cohort_month, count(distinct customer_id) as customers
from (
Select customer_id, 
min(o.order_date) as first_date_of_purchase
from orders o
group by customer_id
)t
group by cohort_month;                           -- cohort analysis

/*Market Basket Analysis (Product Association)
This identifies products frequently purchased together.
Used by companies like:
Amazon
Walmart
This powers recommendations like:
“Customers who bought this also bought…”*/

Select a.product_id as product1, b.product_id as product2,
count(*) as pair_frequency
from orders_item a 
join orders_item b 
on a.order_id = b.order_id
And a.product_id < b.product_id 
group by product1, product2
order by pair_frequency;

/*Customer Churn Risk Analysis
Churn means customers stop buying.
You can detect customers who haven’t purchased recently.*/

SELECT
customer_id,
MAX(order_date) AS last_purchase
FROM orders
GROUP BY customer_id
HAVING last_purchase < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
















