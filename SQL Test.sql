**Q1**

SELECT
user_id
,user_name
FROM User 
WHERE
staff_id  = ‘ThuyNT’

**Q2**

SELECT
		date_trunc (‘day’, order_date)
		,sum(stop_point) as total_stop_point
	FROM Order
	WHERE
		date_trunc (‘day’, order_date) >= ‘2020-03-01’
		And date_trunc (‘day’, order_date) <= ‘2020-03-15’
	GROUP BY
		date_trunc (‘day’, order_date)
	ORDER BY
		date_trunc (‘day’, order_date)

**Q3**

WITH d_sp AS (
		SELECT 
(discount/stop_point) AS d_sp
,order_date
		FROM Order
WHERE EXTRACT (month from order_date) = 3 
)
	SELECT avg (d_sp)
	FROM d_sp

**Q4**

SELECT 
Staff.staff_id
		,Staff.staff_name
		,SUM(Order.stop_point)/monthly_target*100 as complete_mounthly_target
	FROM Order
	JOIN User ON User.user_id = Order.user_id
	JOIN Staff ON Staff.staff_id = User. staff_id
	WHERE Order.order_date >= ‘2020-03-01’
		and Order.order_date <= ‘2020-03-31’
	GROUP BY Staff.staff_id

**Q5**

SELECT 
		User.category
		,sum(Order.stop_point) as total_stop_point
	FROM Order
	JOIN User ON User.user_id = Order.user_id
	WHERE Order.order_date >= ‘2020-03-01’
		AND Order.order_date <= ‘2020-03-31’
	GROUP BY User.category
	ORDER BY total_stop_point DESC
	LIMIT 3

**Q6**

SELECT 
Staff.staff_id
		,Staff.staff_name
		,SUM(total_fee) as total_revenue
	FROM Order
	JOIN User ON User.user_id = Order.user_id
	JOIN Staff ON Staff.staff_id = User.staff_id
	WHERE Order.order_date = ‘2020-01-03’
	GROUP BY Staff.staff_id
   
**Q7**

WITH stop_point_daily as (
		SELECT 
sum(stop_point) as sum_stop_point
			,date_trunc (‘day’, order_date) as daily
		FROM Order
		GROUP BY daily
	SELECT 
		date_trunc (‘month’, daily) as month
		max (sum_stop_point) as max_stop_point_daily
		FROM stop_point_daily
		GROUP BY month
		ORDER BY month
   
**Q8**
    
WITH t_sp AS (
		SELECT 
			Order.order_date
			,User.user_name
			,sum(Order.stop_point) as t_sp
		FROM Order
		JOIN User ON User.user_id = Order.user_id
		GROUP BY User.user_name
		)
SELECT
		date_trunc (‘month’, order_date) as order_month
		,user_name
		,max(t_sp) as total_stop_point
	FROM t_sp
	GROUP BY order_month
	ORDER BY order_month

**Q9**

SELECT 
		,Staff.staff_name
		,SUM(Order.stop_point) / Staff.monthly_target * 100 AS complete_target
		,CASE AS total_salary
			WHEN complete_target <100 THEN 0.8 * Staff.base_salary
			WHEN complete_target =100 THEN Staff.base_salary
			WHEN complete_target >100 THEN Staff.base_salary + 20000*(1-complete_target/100)*complete_target
		END as total_salary
	FROM Order
	JOIN User ON User.user_id = Order.user_id
	JOIN Staff ON Staff.staff_id = User. staff_id
	WHERE Order.order_date >= ‘2020-03-01’
		and Order.order_date <= ‘2020-03-31’
	GROUP BY Staff.staff_name
    
 **Q10**
    
With temp as (select staff_name, extract(month from order_date) as month,sum(stop_point) as stop_point
from order left join user using (user_id) left join staff using (staff_id) 
where extract(month from order_date) between 2 and 5 group by 1,2 order by 1,2 )

Select staff_name,
(lead(stop_point,1) over (partition by staff_name order by month)/stop_point - 1) as M03_growth_rate,
(lead(stop_point,2) over (partition by staff_name order by month)/(lead(stop_point,1) over (partition by staff_name order by month) -1) as M04_growth_rate,
(lead(stop_point,3) over (partition by staff_name order by month)/(lead(stop_point,2) over (partition by staff_name order by month) -1) as M05_growth_rate from temp
