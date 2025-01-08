create database pizza_sales;
use pizza_sales;

create table orders(
order_id int primary key,
order_Date date not null,
order_time time not null
);

create table order_details(
order_details_id int primary key,
order_id	int,
pizza_id	text,
quantity int
);

-- Retrive the total numbers of order placed 
select count(order_id) from orders as Total_orders_placed;


--  Calculate the total revenue generated from pizza sales
select round(sum(order_details.quantity* pizzas.price),2)  as Total_revenue
from order_details
join pizzas
on pizzas.pizza_id = order_details.pizza_id;


-- Identify the highest priced pizza
select pizza_types.name ,pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc
limit 1;


-- Identify the most common pizza size ordered
select pizzas.size as most_common_size, count(order_details.order_details_id) as order_count 
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by order_count desc
limit 1;


-- List the top 5 most ordered pizza types along with their quantities 
select pizza_types.name , sum(order_details.quantity ) as quantity
from pizza_types
join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by quantity desc
limit 5;

-- Join the neccesary tables to find the total quantity of each pizza category ordered
select  pizza_types.category, sum(order_details.quantity) as quantity 
from pizza_types 
join pizzas
on  pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity desc ;


-- determine the distribution of orders by hour of the day.
select hour(order_time) as hour , count(order_id) as order_count
from orders
group by hour
order by hour asc;


-- join the relevant tables to find the category wise distribuion of pizzas
select category , count(name) 
from pizza_types
group by category;


-- Group the orders by date and calculate the average number of pizzas ordered per day
select round(avg(quantity))  from
(select orders.order_date , sum(order_details.quantity) as quantity 
from orders 
join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue
SELECT  pizza_types.name, round(sum(order_details.quantity * pizzas.price))AS revenue
FROM pizza_types
JOIN pizzas
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by revenue desc
limit 3;


--  calculate the percentage contribution of each pizza type to total revenue
SELECT  pizza_types.category,round(sum(order_details.quantity * pizzas.price)/ (select sum(order_details.quantity *pizzas.price) as total_sales
from order_details
join pizzas
on pizzas.pizza_id = order_details.pizza_id)*100,2) AS revenue
FROM pizza_types
JOIN pizzas
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category
order by revenue desc;


-- Analyze the cmulative revenue generated over time 
select order_date, sum(revenue) over (order by order_date) as cum_revenue
from
(select orders.order_date,sum(order_details.quantity*pizzas.price) as revenue 
from order_details 
join pizzas 
on order_details.pizza_id = pizzas.pizza_id
join orders 
on orders.order_id = order_details.order_id
group by orders.order_date) as sales;