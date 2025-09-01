--First Query: to get total curstomers, total churn and the rate
WITH general_info as (SELECT
    SUM(CASE
        WHEN "Churn" = 1 THEN 1
    END) AS churn_total,
    COUNT(*) AS Total
FROM
churn
)

SELECT
	churn_total,
	Total,
	CAST(churn_total as DECIMAL)/Total as churn_rate -- Cast to avoid integer division and get 0 as a result
FROM
	general_info

--Second Query to get top 10 State with more churn rate and general info

WITH churn_by_state AS (
    SELECT 
        "State",
		--to get the total churn by state
        SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) AS churn_customers,
        COUNT(*) AS total_customers,
		--to get the chutn rate
        CAST(SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) AS DECIMAL) / COUNT(*) AS churn_rate
    FROM churn
    GROUP BY "State"
)
SELECT *
FROM (
    SELECT *,
           RANK() OVER (ORDER BY churn_rate DESC) AS churn_rank
    FROM churn_by_state
) ranked
WHERE churn_rank <= 10
--Third Query: to get avg behaivor group by churn
SELECT
AVG("Total day minutes") as Total_day_min,
AVG("Total eve minutes") as Total_eve_min,
AVG("Total night minutes") as Total_night_min,
AVG("Total intl minutes") as Total_intl_min,
AVG("Customer service calls") as Customer_service_calls
FROM
churn
GROUP BY "Churn"
