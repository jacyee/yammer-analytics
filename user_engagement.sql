-- weekly active user as engagement level
SELECT DATE_TRUNC('week', e.occurred_at) as day_of_week,
       COUNT(DISTINCT e.user_id) AS weekly_active_users
FROM tutorial.yammer_events e
WHERE e.event_type = 'engagement'
GROUP BY 1
ORDER BY 1 


