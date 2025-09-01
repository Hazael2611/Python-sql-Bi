--Query to get total curstomers, total churn and the rate
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
