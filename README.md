[![Code Climate](https://codeclimate.com/github/equivalent/sendgrid_event_webhook_collector/badges/gpa.svg)](https://codeclimate.com/github/equivalent/sendgrid_event_webhook_collector)
[![Build Status](https://travis-ci.org/equivalent/sendgrid_event_webhook_collector.svg)](https://travis-ci.org/equivalent/sendgrid_event_webhook_collector)

# Database

Migrate databas

```
rake db:migrate               # for development
RACK_ENV=test rake db:migrate # for test
```

# Running server

```sh
# production enforcing ssl
bundle exec foreman start

# development on port 3000 without ssl enforce
RACK_ENV=development PORT=3000 bundle exec foreman start
```

If used under Heroku, Procfile is set up to Unicorn.

# User authentication

```
# using header (recommended)
curl -XGET -H 'Authorization: Token xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' http://localhost:3000/events

# using param
curl -XGET http://localhost:3000/events?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

# Usage documentation

See request specs

# Restricted arg names

```
ip
id
href
category
event
name
email
timestamp
occuredAt
occured_at
created_at
createdAt
updated_at
updatedAt
sg_message_id
sg_event_id
useragent
```

# todo

* POST Event shoud return serialized event not just post of public_uids
* configuration file
  * option to force https on production
  * option for authority (http://whatever)
* make a gem from app
