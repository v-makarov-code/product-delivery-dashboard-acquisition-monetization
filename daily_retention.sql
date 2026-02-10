SELECT
  DATE_TRUNC('month', start_date) as start_month,
  start_date,
  dt - start_date as day_number,
  ROUND(
    COUNT(DISTINCT user_id) :: decimal / MAX(COUNT(DISTINCT user_id)) OVER(PARTITION BY start_date),
    2
  ) as retention
FROM(
    SELECT
      user_id,
      MIN(time :: DATE) OVER(PARTITION BY user_id) as start_date,
      time :: DATE as dt
    FROM
      user_actions
  ) t1
GROUP BY
  dt,
  start_date
ORDER BY
  start_date,
  day_number