[![Code Climate](https://codeclimate.com/github/equivalent/sendgrid_event_webhook_collector/badges/gpa.svg)](https://codeclimate.com/github/equivalent/sendgrid_event_webhook_collector)
[![Build Status](https://travis-ci.org/equivalent/sendgrid_event_webhook_collector.svg)](https://travis-ci.org/equivalent/sendgrid_event_webhook_collector)

# Database

Migrate databas

```
rake db:migrate               # for development
RACK_ENV=test rake db:migrate # for test
```

# User authentication

```
# using header (recommended)
curl -XGET -H 'Authorization: Token xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' http://localhost:9393/events

# using param
curl -XGET http://localhost:9393/events?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

# Restricted arg names

```
category
event
name
email
timestamp
```
