use data_analysis;
-- Feature Engineering:
-- Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. 
-- This will help answer the question on which part of the day most sales are made.
SET SQL_SAFE_UPDATES = 0;
UPDATE amazon
SET timeofday =
    CASE 
        WHEN HOUR(time) >= 6 AND HOUR(time) <= 12 THEN 'MORNING'
        WHEN HOUR(time) > 12 AND HOUR(time) <= 18 THEN 'AFTERNOON'
        ELSE 'NIGHT'
    END
WHERE TIMEOFDAY IS NULL;





-- Add a new column named dayname that contains the extracted days of the week on which the given transaction 
-- took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.



ALTER TABLE AMAZON
ADD COLUMN DAYNAME VARCHAR(100);
UPDATE AMAZON
SET DAYNAME=DAYNAME(DATE)
WHERE dayname IS NULL;



-- Add a new column named monthname that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.
ALTER TABLE AMAZON
ADD MONTHNAME TEXT;
UPDATE AMAZON
SET MONTHNAME=monthname(DATE)
WHERE MONTHNAME IS NULL;
SELECT * FROM AMAZON;




/*Product Analysis
Conduct analysis on the data to understand the different product lines, the products lines 
performing best and the product lines that need to be improved.*/




select product_line from amazon; 
select distinct(product_line) from amazon;
select product_line,count(*) as most_occur_item
from amazon
group by product_line order by most_occur_item desc;


#  distinct productline are 6 in that
# most occuring value is food and bevarages and electronic accessories in second place.
select gender,count(product_line) 
from amazon
group by gender ;
# mostly male and female purchasing is same 
select city,count(product_line) 
from amazon
group by city ;


# mostly all cities productlines count similar


SELECT

    product_line,
    SUM(total) AS total_sales,
    AVG(total) AS avg_sales,
    SUM(quantity) AS total_quantity_sold
FROM
    amazon
GROUP BY
    product_line
ORDER BY
    total_sales DESC; 



/*
Sales Analysis

This analysis aims to answer the question of the sales trends of product. 
The result of this can help us measure the effectiveness of each sales strategy the business applies and 
what modifications are needed to gain more 
*/
select * from amazon;
SELECT
    product_line,
    SUM(total) AS total_sales
FROM
    amazon
GROUP BY
    product_line
ORDER BY
    total_sales DESC; 
# most of the income gained by 'Food and beverages' so it is best to focus and food with innovative food items
select monthname(Date),sum(total)
from amazon
group by monthname(Date)
order by sum(total) desc; # it will give you the total sales for each month here januaary month has more sales.


select dayname(Date),sum(total)
from amazon
group by dayname(Date)
order by sum(total) desc; # mostly saturday sales are in high so 














/*Customer Analysis 
This analysis aims to uncover the different customer segments, purchase trends and the profitability of each customer segment.*/
select gender,count(rating) from amazon group by gender #both males and female almost customers gives equal ratings
;
use data_analysis;
select
case when rating between 1 and 5 then 'not satisfy'
when rating between 6 and 8 then 'ok ok'
else 'vistis again' end as rating_perforamnce,
count(*) as best_rating
from amazon
group by
case when rating between 1 and 5 then 'not satisfy'
when rating between 6 and 8 then 'ok ok'
else 'vistis again' end # most of the customers visit again 






select * from amazon;
#1. What is the count of distinct cities in the dataset?

select count(distinct(city))from amazon;

#2. For each branch, what is the corresponding city?

select distinct branch,city from amazon;
#3. What is the count of distinct product lines in the dataset?

select count(distinct(product_line)) from amazon;

#4. Which payment method occurs most frequently?

select payment,count(*) occured_most
from amazon
group by payment;

#5. Which product line has the highest sales?

select product_line,sum(total) as highest_sales
from amazon
group by product_line
order by sum(total) desc;

#6. How much revenue is generated each month?

select city,sum(total) as total_revenue_each_month from amazon group by city;
		#alternative query
select monthname,sum(total) total_revenue_each_month from amazon group by monthname;


#7. In which month did the cost of goods sold reach its peak?

select 
	monthname,sum(cogs) as cogs
from 
	amazon 
group by 
	monthname
order by 
	cogs desc limit 1;

#8. Which product line generated the highest revenue?
SELECT
    product_line,
    SUM(total) AS total_sales
FROM
    amazon
GROUP BY
    product_line
ORDER BY
    total_sales DESC; 

#9. In which city was the highest revenue recorded?
SELECT
    city,
    SUM(total) AS total_sales
FROM
    amazon
GROUP BY
    city
ORDER BY
    total_sales DESC
limit 1; 
#10. Which product line incurred the highest Value Added Tax?
select 
	product_line ,
    sum(vat)as incurred_the_highest_Value_Added_Tax
from 
	amazon
group by product_line
order by incurred_the_highest_Value_Added_Tax desc limit 1;

#11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

select product_line,
case when total>(SELECT avg(total) FROM AMAZON) then 'GOOD'
ELSE 'BAD' END AS PERFOMANCE
FROM AMAZON;

#12. Identify the branch that exceeded the average number of products sold.

SELECT BRANCH,SUM(quantity) AS SUM_OF_quantity
FROM AMAZON
GROUP BY BRANCH
HAVING SUM(quantity)>(select avg(total) from amazon);

#13. Which product line is most frequently associated with each gender?

SELECT GENDER,PRODUCT_LINE,COUNT(PRODUCT_LINE)
FROM AMAZON 
GROUP BY GENDER,PRODUCT_LINE
ORDER BY COUNT(PRODUCT_LINE) DESC;


#14. Calculate the average rating for each product line.

select product_line,avg(rating) as ratings
from amazon
group by product_line order by avg(rating) desc;

#15. Count the sales occurrences for each time of day on every weekday.

SELECT
	DAYNAME,TIMEOFDAY,SUM(TOTAL) 
FROM 
	AMAZON 
GROUP BY 
	DAYNAME,TIMEOFDAY
ORDER BY 
	DAYNAME ASC;

#16. Identify the customer type contributing the highest revenue.
select customer_type,sum(total) as highest_revenue
from amazon
group by customer_type
order by highest_revenue desc;
/*select *  from amazon;
SET SQL_SAFE_UPDATES = 0;
UPDATE amazon
SET date = STR_TO_DATE(date, '%m/%d/%Y');
desc amazon;
alter table amazon
modify column time time */ #the entire process is about change the datatype for columns

#17. Determine the city with the highest VAT percentage.
/*ALTER TABLE amazon
RENAME COLUMN `Tax_5%` TO VAT;*/



SELECT CITY, SUM(VAT)/SUM(TOTAL)*100 AS highest_VAT_percentage
FROM AMAZON
GROUP BY CITY
order by highest_VAT_percentage DESC;



#18. Identify the customer type with the highest VAT payments.
SELECT customer_type, SUM(VAT) AS highest_VAT_payments
FROM AMAZON
GROUP BY customer_type
order by highest_VAT_payments DESC;


#19. What is the count of distinct customer types in the dataset?
select count(distinct(customer_type)) from amazon;

#20. What is the count of distinct payment methods in the dataset?
select count(distinct(payment)) from amazon;

#21. Which customer type occurs most frequently?

select customer_type,count(*) most_frequently
from amazon
group by customer_type
order by most_frequently desc limit 1;

#22. Identify the customer type with the highest purchase frequency.

select customer_type,sum(total) most_frequently
from amazon
group by customer_type
order by most_frequently desc limit 1;


#23. Determine the pre dominant gender among customers.
select gender,sum(total) pre_dominant
from amazon
group by gender
order by pre_dominant desc ;# this is not enough information to solve here gender predominent given ,but they dont mentioned on transaction or total_purachase_basis

#24. Examine the distribution of genders within each branch.
SELECT BRANCH,GENDER,COUNT(GENDER)
FROM AMAZON GROUP BY BRANCH,GENDER ORDER BY BRANCH ASC;


#25. Identify the time of day when customers provide the most ratings.
select 
	case 
	WHEN hour(time)>=6 and hour(time)<=12 then 'MORNING'
	WHEN hour(time)>12 and hour(time)<=18 then 'AFTERNOON'
	ELSE 'NIGHT'
	END AS TIMINGS,
	count(rating) as most_ratings
from amazon
group by 
	case 
	WHEN hour(time)>=6 and hour(time)<=12 then 'MORNING'
	WHEN hour(time)>12 and hour(time)<=18 then 'AFTERNOON'
	ELSE 'NIGHT'
	END;
    #alternative query
select timeofday,count(rating) from amazon 
group by timeofday;
    
#26. Determine the time of day with the highest customer ratings for each branch.
select branch,
case 
WHEN hour(time)>=6 and hour(time)<=12 then 'MORNING'
WHEN hour(time)>12 and hour(time)<=18 then 'AFTERNOON'
ELSE 'NIGHT'
END AS TIMINGS,
count(rating) as highest_customer_ratings
from amazon
group by branch,
case
WHEN hour(time)>=6 and hour(time)<=12 then 'MORNING'
WHEN hour(time)>12 and hour(time)<=18 then 'AFTERNOON'
ELSE 'NIGHT' end
order by highest_customer_ratings desc;
  # alternative query
  
select branch,timeofday,count(*) from amazon group by branch,timeofday order by count(*) desc;

#27. Identify the day of the week with the highest average ratings
select dayname(date),avg(rating) as ratings
from amazon
group by dayname(date)
order by ratings desc limit 1;

# akternative query
select dayname,avg(rating) as ratings from amazon group by dayname order by ratings desc limit 1;
#28. Determine the day of the week with the highest average ratings for each branch.
select branch,dayname(date),avg(rating) as ratings
from amazon
group by branch,dayname(date)
order by ratings desc; 
# ALTERNATIVE QUERY
SELECT BRANCH,DAYNAME,AVG(RATING) FROM AMAZON  GROUP BY BRANCH,DAYNAME order by AVG(RATING) DESC










