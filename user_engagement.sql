-- Daily active user as engagement level
SELECT DATE_TRUNC('day', e.occurred_at) as day_of_week,
       COUNT(DISTINCT e.user_id) AS daily_active_users
FROM tutorial.yammer_events e
WHERE e.event_type = 'engagement'
GROUP BY 1
ORDER BY 1 

-- Activated user as engagement level
SELECT date_trunc('day',created_at) as day_of_week,
COUNT(case when activated_at is not null THEN u.user_id else null end) as activated_users
  FROM tutorial.yammer_users u
  where created_at > '2014-05-01' and created_at<'2014-09-01'
 GROUP BY 1
 ORDER BY 1

-- engagement retention rate by user age cohort from sign up
SELECT DATE_TRUNC('week',t.occurred_at) AS "week",
        AVG(t.event_age) AS "Average event age",
       COUNT(DISTINCT CASE WHEN t.user_age > 70 THEN t.user_id ELSE NULL END) AS ">10 weeks",
       COUNT(DISTINCT CASE WHEN t.user_age < 70 AND t.user_age >= 63 THEN t.user_id ELSE NULL END) AS "9 weeks",
       COUNT(DISTINCT CASE WHEN t.user_age < 63 AND t.user_age >= 56 THEN t.user_id ELSE NULL END) AS "8 weeks",
       COUNT(DISTINCT CASE WHEN t.user_age < 56 AND t.user_age >= 49 THEN t.user_id ELSE NULL END) AS "7 weeks",
       COUNT(DISTINCT CASE WHEN t.user_age < 49 AND t.user_age >= 42 THEN t.user_id ELSE NULL END) AS "6 weeks",
       COUNT(DISTINCT CASE WHEN t.user_age < 42 AND t.user_age >= 35 THEN t.user_id ELSE NULL END) AS "5 weeks",
       COUNT(DISTINCT CASE WHEN t.user_age < 35 AND t.user_age >= 28 THEN t.user_id ELSE NULL END) AS "4 weeks",
       COUNT(DISTINCT CASE WHEN t.user_age < 28 AND t.user_age >= 21 THEN t.user_id ELSE NULL END) AS "3 weeks",
       COUNT(DISTINCT CASE WHEN t.user_age < 21 AND t.user_age >= 14 THEN t.user_id ELSE NULL END) AS "2 weeks",
       COUNT(DISTINCT CASE WHEN t.user_age < 14 AND t.user_age >= 7 THEN t.user_id ELSE NULL END) AS "1 week",
       COUNT(DISTINCT CASE WHEN t.user_age < 7 THEN t.user_id ELSE NULL END) AS "<1 week"
  FROM (
        SELECT e.occurred_at,
               u.user_id,
               EXTRACT('day' FROM e.occurred_at - u.activated_at) AS event_age,
               EXTRACT('day' FROM '2014-09-01'::TIMESTAMP - u.activated_at) AS user_age
          FROM tutorial.yammer_users u
          JOIN tutorial.yammer_events e
            ON e.user_id = u.user_id
           AND e.event_type = 'engagement'
           AND e.event_name = 'login'
           AND e.occurred_at >= '2014-05-01'
           AND e.occurred_at < '2014-09-01'
         WHERE u.activated_at IS NOT NULL
       ) t
 GROUP BY 1
 ORDER BY 1
 limit 50



