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
       COUNT(DISTINCT CASE WHEN t.user_age < 7 THEN t.user_id ELSE NULL END) AS "<5 week"
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
 
 
 -- engagement of user by device type
SELECT DATE_TRUNC('week', occurred_at) AS week,
       COUNT(DISTINCT e.user_id) AS weekly_active_users,
       COUNT(DISTINCT CASE WHEN e.device IN ('macbook pro','lenovo thinkpad','macbook air','dell inspiron notebook',
          'asus chromebook','dell inspiron desktop','acer aspire notebook','hp pavilion desktop','acer aspire desktop','mac mini')
          THEN e.user_id ELSE NULL END) AS desktop,
       COUNT(DISTINCT CASE WHEN e.device IN ('iphone 5','samsung galaxy s4','nexus 5','iphone 5s','iphone 4s','nokia lumia 635',
       'htc one','samsung galaxy note','amazon fire phone') THEN e.user_id ELSE NULL END) AS mobile,
        COUNT(DISTINCT CASE WHEN e.device IN ('ipad air','nexus 7','ipad mini','nexus 10','kindle fire','windows surface',
        'samsumg galaxy tablet') THEN e.user_id ELSE NULL END) AS tablet
  FROM tutorial.yammer_events e
 WHERE e.event_type = 'engagement'
   AND e.event_name = 'login'
 GROUP BY 1
 ORDER BY 1
LIMIT 100

 -- engagement of user by email action type
SELECT DATE_TRUNC('month', occurred_at) AS month,
       COUNT(CASE WHEN e.action = 'sent_weekly_digest' THEN e.user_id ELSE NULL END) AS weekly_email,
       COUNT(CASE WHEN e.action = 'sent_reengagement_email' THEN e.user_id ELSE NULL END) AS reengagement_email,
       COUNT(CASE WHEN e.action = 'email_open' THEN e.user_id ELSE NULL END) AS email_open,
       COUNT(CASE WHEN e.action = 'email_clickthrough' THEN e.user_id ELSE NULL END) AS email_clickthrough
  FROM tutorial.yammer_emails e
  where e.occurred_at >= '2014-05-01'
           AND e.occurred_at < '2014-09-01'
 GROUP BY 1
 ORDER BY 1
 
 
 
 -- user retention by weekly email open & CTR rate
SELECT week,
       weekly_opens/CASE WHEN weekly_emails = 0 THEN 1 ELSE weekly_emails END::FLOAT AS weekly_open_rate,
       weekly_ctr/CASE WHEN weekly_opens = 0 THEN 1 ELSE weekly_opens END::FLOAT AS weekly_ctr,
       retain_opens/CASE WHEN retain_emails = 0 THEN 1 ELSE retain_emails END::FLOAT AS retain_open_rate,
       retain_ctr/CASE WHEN retain_opens = 0 THEN 1 ELSE retain_opens END::FLOAT AS retain_ctr
  FROM (
SELECT DATE_TRUNC('week',e1.occurred_at) AS week,
       COUNT(CASE WHEN e1.action = 'sent_weekly_digest' THEN e1.user_id ELSE NULL END) AS weekly_emails,
       COUNT(CASE WHEN e1.action = 'sent_weekly_digest' THEN e2.user_id ELSE NULL END) AS weekly_opens,
       COUNT(CASE WHEN e1.action = 'sent_weekly_digest' THEN e3.user_id ELSE NULL END) AS weekly_ctr,
       COUNT(CASE WHEN e1.action = 'sent_reengagement_email' THEN e1.user_id ELSE NULL END) AS retain_emails,
       COUNT(CASE WHEN e1.action = 'sent_reengagement_email' THEN e2.user_id ELSE NULL END) AS retain_opens,
       COUNT(CASE WHEN e1.action = 'sent_reengagement_email' THEN e3.user_id ELSE NULL END) AS retain_ctr
  FROM tutorial.yammer_emails e1
  LEFT JOIN tutorial.yammer_emails e2
    ON e2.occurred_at >= e1.occurred_at
   AND e2.occurred_at < e1.occurred_at + INTERVAL '5 MINUTE'
   AND e2.user_id = e1.user_id
   AND e2.action = 'email_open'
  LEFT JOIN tutorial.yammer_emails e3
    ON e3.occurred_at >= e2.occurred_at
   AND e3.occurred_at < e2.occurred_at + INTERVAL '5 MINUTE'
   AND e3.user_id = e2.user_id
   AND e3.action = 'email_clickthrough'
 WHERE e1.occurred_at >= '2014-06-01'
   AND e1.occurred_at < '2014-09-01'
   AND e1.action IN ('sent_weekly_digest','sent_reengagement_email')
 GROUP BY 1
       ) a
 ORDER BY 1


-- A/B test beteween treatment group and control group for feature evaluation

-- Average Messages Sent per Existing Users
SELECT c.experiment,
       c.experiment_group,
       c.users,
       c.total_treated_users,
       ROUND(c.users/c.total_treated_users,4) AS treatment_percent,
       c.total,
       ROUND(c.average,4)::FLOAT AS average,
       ROUND(c.average - c.control_average,4) AS rate_difference,
       ROUND((c.average - c.control_average)/c.average,4) AS rate_lift,
       ROUND(c.stdev,4) AS stdev,
       ROUND((c.average - c.control_average) /
          SQRT((c.variance/c.users) + (c.control_variance/c.control_users))
        ,4) AS t_stat,
       (1 - COALESCE(nd.value,1))*2 AS p_value
  FROM (
SELECT *,
       MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.users ELSE NULL END) OVER () AS control_users,
       MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.average ELSE NULL END) OVER () AS control_average,
       MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.total ELSE NULL END) OVER () AS control_total,
       MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.variance ELSE NULL END) OVER () AS control_variance,
       MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.stdev ELSE NULL END) OVER () AS control_stdev,
       SUM(b.users) OVER () AS total_treated_users
  FROM (
SELECT a.experiment,
       a.experiment_group,
       COUNT(a.user_id) AS users,
       AVG(a.metric) AS average,
       SUM(a.metric) AS total,
       STDDEV(a.metric) AS stdev,
       VARIANCE(a.metric) AS variance
  FROM (
SELECT ex.experiment,
       ex.experiment_group,
       ex.occurred_at AS treatment_start,
       u.user_id,
       u.activated_at,
       COUNT(CASE WHEN e.event_name = 'send_message' THEN e.user_id ELSE NULL END) AS metric
  FROM (SELECT user_id,
               experiment,
               experiment_group,
               occurred_at
          FROM tutorial.yammer_experiments
         WHERE experiment = 'publisher_update'
       ) ex
  JOIN tutorial.yammer_users u
    ON u.user_id = ex.user_id
   AND u.activated_at < '2014-06-01'
  JOIN tutorial.yammer_events e
    ON e.user_id = ex.user_id
   AND e.occurred_at >= ex.occurred_at
   AND e.occurred_at <= '2014-07-01'
   AND e.event_type = 'engagement'
 GROUP BY 1,2,3,4,5
       ) a
 GROUP BY 1,2
       ) b
       ) c
  LEFT JOIN benn.normal_distribution nd
    ON nd.score = ABS(ROUND((c.average - c.control_average)/SQRT((c.variance/c.users) + (c.control_variance/c.control_users)),3))
-- login frequency /average of logins per user

-- average days engaged per user


--search vs autocomplete function usage
SELECT DATE_TRUNC('week',z.session_start) AS week,
       COUNT(*) AS sessions,
       COUNT(CASE WHEN z.autocompletes > 0 THEN z.session ELSE NULL END) AS with_autocompletes,
       COUNT(CASE WHEN z.runs > 0 THEN z.session ELSE NULL END) AS with_runs
  FROM (
SELECT x.session_start,
       x.session,
       x.user_id,
       COUNT(CASE WHEN x.event_name = 'search_autocomplete' THEN x.user_id ELSE NULL END) AS autocompletes,
       COUNT(CASE WHEN x.event_name = 'search_run' THEN x.user_id ELSE NULL END) AS runs,
       COUNT(CASE WHEN x.event_name LIKE 'search_click_%' THEN x.user_id ELSE NULL END) AS clicks
  FROM (
SELECT e.*,
       session.session,
       session.session_start
  FROM tutorial.yammer_events e
  LEFT JOIN (
       SELECT user_id,
              session,
              MIN(occurred_at) AS session_start,
              MAX(occurred_at) AS session_end
         FROM (
              SELECT bounds.*,
              		    CASE WHEN last_event >= INTERVAL '10 MINUTE' THEN id
              		         WHEN last_event IS NULL THEN id
              		         ELSE LAG(id,1) OVER (PARTITION BY user_id ORDER BY occurred_at) END AS session
                FROM (
                     SELECT user_id,
                            event_type,
                            event_name,
                            occurred_at,
                            occurred_at - LAG(occurred_at,1) OVER (PARTITION BY user_id ORDER BY occurred_at) AS last_event,
                            LEAD(occurred_at,1) OVER (PARTITION BY user_id ORDER BY occurred_at) - occurred_at AS next_event,
                            ROW_NUMBER() OVER () AS id
                       FROM tutorial.yammer_events e
                      WHERE e.event_type = 'engagement'
                      ORDER BY user_id,occurred_at
                     ) bounds
               WHERE last_event >= INTERVAL '10 MINUTE'
                  OR next_event >= INTERVAL '10 MINUTE'
               	 OR last_event IS NULL
              	 	 OR next_event IS NULL   
              ) final
        GROUP BY 1,2
        
       ) session
    ON e.user_id = session.user_id
   AND e.occurred_at >= session.session_start
   AND e.occurred_at <= session.session_end
 WHERE e.event_type = 'engagement'
       ) x
 GROUP BY 1,2,3
       ) z
 GROUP BY 1
 ORDER BY 1
