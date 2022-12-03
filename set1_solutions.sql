-- create database sql_assignment;

-- use sql_assignment;

 select * from city;

-- describe city;

-- alter table city modify column id int;

######################################################################################################

-- Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
-- The CountryCode for America is USA.


select * from city where countrycode = 'USA' and population > 100000;


-- Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000. 
-- The CountryCode for America is USA.


select * from city where countrycode = 'USA' and population > 120000;


-- Q3. Query all columns (attributes) for every row in the CITY table.

select * from city ;


-- Q4. Query all columns for a city in CITY with the ID 1661.

select * from city where id = 1661;


-- Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.

select * from city where countrycode = 'JPN';


-- Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.

select name from city where countrycode = 'JPN';


--  Q7. Query a list of CITY and STATE from the STATION table.


select city, state 
from station 
;

select * from station;

-- Q8. Query a list of CITY names from STATION for cities that have an even ID number. 
-- Print the results in any order, but exclude duplicates from the answer.

select city from station where id%2 = 0;



-- Q9. Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.

select (count(city) - count(distinct city)) as count_diff_city from station ;


-- Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths 
-- (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that 
-- comes first when ordered alphabetically.

with cte_city as(
select city, length(city) as length_city
from station )

select city, length_city , 'max_length' as type_length from
cte_city where length_city = (select max(length_city) from cte_city)
union 
select city, length_city , 'min_length' as type_length from
cte_city where length_city = (select min(length_city) from cte_city)
order by city ;


-- Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION.
--  Your result cannot contain duplicates.

select distinct city as city_names_vowels
from station
where left(city,1) in ('a','e','i','o','u');


-- Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.

select distinct city as city_names_vowels_end
from station
where right(city,1) in ('a','e','i','o','u');



-- Q13. Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.

select distinct city as city_names_non_vowels
from station
where left(city,1) not in ('a','e','i','o','u');


-- Q14. Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.

select distinct city as city_names_non_vowels_end
from station
where right(city,1) not in ('a','e','i','o','u');


-- Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. 
-- Your result cannot contain duplicates.

select distinct city as city_names_non_vowels_all
from station
where left(city,1) not in ('a','e','i','o','u')
or right(city,1) not in ('a','e','i','o','u');


-- Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. 
-- Your result cannot contain duplicates.

select distinct city as city_names_non_vowels_both
from station
where left(city,1) not in ('a','e','i','o','u')
and right(city,1) not in ('a','e','i','o','u');



-- create table product
-- (
-- product_id int,
-- product_name varchar(20),
-- unit_price double
-- );

-- insert into product values(1,'S8',1000),(2,'G4',800),(3,'iPhone',1400);


create table sales
(
seller_id int,
product_id int,
buyer_id int,
sale_date date,
quantity int,
price int
);

SELECT * FROM product;
select * from sales;


insert into sales values
(1,1,1,'2019-01-21',2,2000),
(1, 2 ,2, '2019-02-17', 1, 800), 
(2 ,2, 3, '2019-06-02', 1, 800),
(3, 3, 4, '2019-05-13', 2, 2800);


-- Q17. Write an SQL query that reports the products that were only sold in the first quarter of 2019. 
-- That is, between 2019-01-01 and 2019-03-31 inclusive.

select p.product_id as product_id ,p.product_name as product_name
from product p 
join sales s 
using(product_id)
where s.sale_date between '2019-01-01' and '2019-03-31'
group by p.product_id 
having count(p.product_id) =1
;



use sql_assignment;
create table views 
(
	article_id int,
    author_id int,
    viewer_id int,
    view_date date
);

insert into views values
(1 ,3 ,5 ,'2019-08-01'),
(1 ,3 ,6 ,'2019-08-02'),
(2, 7, 7 ,'2019-08-01'),
(2 ,7 ,6 ,'2019-08-02'),
(4 ,7 ,1 ,'2019-07-22'),
(3 ,4 ,4 ,'2019-07-21'),
(3 ,4 ,4 ,'2019-07-21');

select * from views;

create table delivery(
delivery_id int,
customer_id int,
order_date date,
customer_pref_delivery_date date
);

insert into delivery values
(1, 1, '2019-08-01' ,'2019-08-02'),
(2 ,5 ,'2019-08-02' ,'2019-08-02'),
(3 ,1 ,'2019-08-11' ,'2019-08-11'),
(4 ,3 ,'2019-08-24' ,'2019-08-26'),
(5 ,4 ,'2019-08-21' ,'2019-08-22'),
(6 ,2 ,'2019-08-11' ,'2019-08-13');

select * from delivery;


-- Q18 . Write an SQL query to find all the authors that viewed at least one of their own articles. Return the result table sorted by id in ascending order.

select distinct v1.author_id as id
from views v1 join
views v2 on v1.author_id = v2.viewer_id
order by id;



-- Q19. The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date 
-- (on the same order date or after it). If the customer's preferred delivery date is the same as the order date, 
-- then the order is called immediately; otherwise, it is called scheduled. Write an SQL query to find the percentage of immediate orders in the table,
--  rounded to 2 decimal places.
with delivery_cte as
(
select *,
case when order_date = customer_pref_delivery_date then 'Immidiate'
else 'Scheduled' end as order_prefernce
 from delivery
)

 select distinct round((select count(delivery_id) from delivery_cte
where order_prefernce = 'Immidiate') / (select count(delivery_id) from delivery_cte)*100,2)  as immidiate_percentage
from delivery_cte;


create table ads
(
ad_id int,
user_id int,
action_name varchar(20)
);

insert into  ads
values
(1 ,1, 'Clicked'),
(2 ,2, 'Clicked'),
(3 ,3, 'Viewed'),
(5 ,5, 'Ignored'),
(1 ,7, 'Ignored'),
(2 ,7, 'Viewed'),
(3 , 5, 'Clicked'),
(1 , 4,  'Viewed'),
(2 , 11, 'Viewed'),
(1 ,2,  'Clicked')
;

