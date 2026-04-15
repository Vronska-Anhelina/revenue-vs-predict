#display the percentage of fulfillment of accumulated income from accumulated goals (predict) by day.




WITH predict AS( --цілі в розрізі дня
  SELECT date,SUM(predict) OVER (ORDER BY date) AS predict_day
  FROM `DA.revenue_predict` rp),
revenue AS (
  SELECT date,SUM(p.price) AS revenue_day --income by day
  FROM `DA.product` p
  JOIN `DA.order` o
  ON p.item_id=o.item_id
  JOIN `DA.session` s
  ON s.ga_session_id=o.ga_session_id
  GROUP BY date),
  commutative_revenue AS( 
    SELECT date, SUM(revenue_day) OVER (ORDER BY date) AS commulative_revenue_day
    FROM revenue ),
  percent AS (
    SELECT predict.date, commulative_revenue_day/predict_day*100 AS percent_of_predict --% of goals achieved
    FROM predict
    JOIN revenue
    ON predict.date=revenue.date
    JOIN commutative_revenue
    ON revenue.date=commutative_revenue.date
    GROUP BY date,commulative_revenue_day,predict_day)
    SELECT date,percent.percent_of_predict
    FROM percent;


