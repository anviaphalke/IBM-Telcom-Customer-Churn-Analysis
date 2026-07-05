-- Q1. How many customers have churned?

SELECT Churn,
COUNT(*) AS total_customers
FROM Customer_churn_tb
GROUP BY Churn;

-- Q2. Which customers have monthly charges above 80 and have churned?

SELECT *
FROM Customer_churn_tb
WHERE MonthlyCharges > 80
AND Churn = 'Yes';

-- Q3. What is the overall customer churn rate?

SELECT
ROUND(
100.0 * SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*),2
) AS churn_rate
FROM Customer_churn_tb;

--Q4. Which contract type has the highest customer churn?

SELECT
Contract,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(
100.0 * SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*),2
) AS churn_rate
FROM Customer_churn_tb
GROUP BY Contract
ORDER BY churn_rate DESC;

--Q5. Which payment methods are associated with the highest churn?

SELECT
PaymentMethod,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(
100.0 * SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*),2
) AS churn_rate
FROM Customer_churn_tb
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

--Q6. Do customers with higher monthly charges churn more?

SELECT
Churn,
ROUND(AVG(MonthlyCharges),2) AS average_monthly_charges,
MIN(MonthlyCharges) AS minimum_charge,
MAX(MonthlyCharges) AS maximum_charge
FROM Customer_churn_tb
GROUP BY Churn;

--Q7. Compare the average tenure of churned and retained customers.

SELECT
Churn,
ROUND(AVG(Tenure),2) AS average_tenure,
MIN(Tenure) AS minimum_tenure,
MAX(Tenure) AS maximum_tenure
FROM Customer_churn_tb
GROUP BY Churn;

--Q8. Which internet service has the highest churn percentage?

SELECT
InternetService,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(
100.0 * SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*),2
) AS churn_rate
FROM Customer_churn_tb
GROUP BY InternetService
ORDER BY churn_rate DESC;

--Q9. Segment customers based on their tenure and count each segment.

WITH customer_segments AS
(
SELECT
Tenure,
CASE
WHEN Tenure < 12 THEN 'New Customer'
WHEN Tenure BETWEEN 12 AND 36 THEN 'Regular Customer'
ELSE 'Loyal Customer'
END AS customer_segment
FROM Customer_churn_tb
)

SELECT
customer_segment,
COUNT(*) AS total_customers
FROM customer_segments
GROUP BY customer_segment;

--Q10. Which contract type generates the highest monthly revenue?

SELECT
Contract,
ROUND(SUM(MonthlyCharges),2) AS total_revenue,
ROUND(AVG(MonthlyCharges),2) AS average_revenue
FROM Customer_churn_tb
GROUP BY Contract
ORDER BY total_revenue DESC;

--Q11. Which combination of telecom services is most common among churned customers?

SELECT
InternetService,
TechSupport,
OnlineSecurity,
COUNT(*) AS churned_customers
FROM Customer_churn_tb
WHERE Churn='Yes'
GROUP BY
InternetService,
TechSupport,
OnlineSecurity
ORDER BY churned_customers DESC
LIMIT 5;

--Q12. Estimate the monthly revenue lost due to customer churn.

SELECT
COUNT(*) AS churned_customers,
ROUND(SUM(MonthlyCharges),2) AS monthly_revenue_lost,
ROUND(AVG(MonthlyCharges),2) AS average_revenue_per_churned_customer
FROM Customer_churn_tb
WHERE Churn='Yes';

--Q13. Rank contract types based on churn rate.

WITH contract_churn AS
(
SELECT
Contract,
ROUND(
100.0 * SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*),2
) AS churn_rate
FROM Customer_churn_tb
GROUP BY Contract
)

SELECT
Contract,
churn_rate,
RANK() OVER(ORDER BY churn_rate DESC) AS churn_rank
FROM contract_churn;