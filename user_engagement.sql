-- weekly active user as engagement level
SELECT DATE_TRUNC('week', e.occurred_at) as day_of_week,
       COUNT(DISTINCT e.user_id) AS weekly_active_users
FROM tutorial.yammer_events e
WHERE e.event_type = 'engagement'
GROUP BY 1
ORDER BY 1 

-- Activation rate as engagement level
SELECT date_trunc('day',created_at) as day_of_week,
COUNT(case when activated_at is not null THEN u.user_id else null end) as activated_users
  FROM tutorial.yammer_users u
  where created_at > '2014-05-01' and created_at<'2014-08-04'
 GROUP BY 1
 ORDER BY 1
