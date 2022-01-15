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
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/57039610/149336388-dd78a4bb-7fc6-47e8-a604-64627e729890.png">

#### 4. engagement of user by device type
-> more significant drop among existing long-time mobile users
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/57039610/149561149-55390211-f46e-4ba4-978b-67778693395f.png">

#### 5. engagement of user by email action type (email sent, open, CTR)
-> more steep drop in CTR of emails
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/57039610/149610811-7ea4f8d8-45f5-431f-b2ae-91adfcc85d01.png">

