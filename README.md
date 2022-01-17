# yammer-analytics
Investigation of user engagement issue using Yammer dataset - _users,events,emails_

data schema
<br>
_users_
<br>
<img width="700" alt="image" src="https://user-images.githubusercontent.com/57039610/149277702-cf3b6b57-cc6a-42ed-9f6c-ef85bc126ff2.png">
<br>
_emails_
<br>
<img width="700" alt="image" src="https://user-images.githubusercontent.com/57039610/149277804-a6f404b4-41ed-4804-9ff5-b7eeac079611.png">
<br>
_events_
<br>
<img width="700" alt="image" src="https://user-images.githubusercontent.com/57039610/149277937-bd693aba-86f8-4d96-9ebc-7c14e1ab0189.png">


Data exploration

#### 1. daily active user as engagement level (by event_type = 'engagement')
-> high growth rate on weekday, low on weekend rolling data
<br>
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/57039610/149192764-3b982642-da1c-4214-839a-42efb8e31972.png">

#### 2. daily signups (by activated_at of users) 
-> high on weekday, low on weekend, exhibit same pattern of engagement level rolling data
<br>
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/57039610/149296743-8b840191-4514-4a29-a3c4-ae60c6c3abc2.png">

#### 3. cohort user based on when user signup - newly sign ups VS existing users 
->  more significant drop in engagement among existing users who signed up for more than 10 weeks
<br>
<img width="500" alt="image" src="https://user-images.githubusercontent.com/57039610/149336388-dd78a4bb-7fc6-47e8-a604-64627e729890.png">

#### 4. engagement of user by device type
-> more significant drop among existing long-time mobile users
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/57039610/149561149-55390211-f46e-4ba4-978b-67778693395f.png">

#### 5. engagement of user by email action type (email sent, open, CTR)
-> steepset drop in CTR of emails for digest emails to mobile apps -> potential problem area to look into
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/57039610/149611048-08b907b2-20f8-4b65-ba6f-394a2a694aea.png">

#### 6. engagement of user by email open rate & CTR
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/57039610/149631509-b955df82-3f00-4ea8-8ca1-66f36907360b.png">

<hr>

A/B test analysis (hypothesis testing & validation of change) of user experience/ behaviour based on feature experiment, whether certain functionality is worth working on with priority, user experience of new feature development & improvement recommendation


_Experiment_ data
<br>
<img width="700" alt="image" src="https://user-images.githubusercontent.com/57039610/149659242-90de068a-fed2-459a-ba55-728aa3a1e972.png">

Explore metrics
#### 1. average message sent 
<img width="800" alt="image" src="https://user-images.githubusercontent.com/57039610/149758562-d73c6b1a-7115-40c8-b380-68c91ee773f1.png">

#### 2. average login per user
#### 3. average days engaged

cohort users by:
new vs. existing users for novelty effect, usage by device, usage by user type (i.e., content producers vs. readers)

