[![Code Climate](https://codeclimate.com/github/equivalent/sendgrid_event_webhook_collector/badges/gpa.svg)](https://codeclimate.com/github/equivalent/sendgrid_event_webhook_collector)
[![Build Status](https://travis-ci.org/equivalent/sendgrid_event_webhook_collector.svg)](https://travis-ci.org/equivalent/sendgrid_event_webhook_collector)


Sendgrid Event Webhook Collector (further refered as `sewc') will enable
you to redirect all your sendgrid event webhook calls
to one place (this app) and allow your other apps to fetch API requests.

Scenario: Imagine you have one Sendgrid account and you want to use it on
several apps/servers. You are cheap and you don't want to pay extra sendgrid accounts.

Solution: You point Sendgrid Event Webhook
url to `sewc`, and then when you want to read the events in your
apps/servers you will send a JSON request to `sewc` to read the events
on category/tag.

Easy peasy, money saver, caching! **$_$**


```
This project is dead at this point as it was forked to a private repo
maintained for needs of company that is using it due to custom
deployment procedure.

I left the public project at 2015-07 and all the code here is working and
up to date with latest Sendgrid. Feel free to fork and carry on where I
left it.
```

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

## Users 

`RACK_ENV=production bundle exec rake user:list`
`RACK_ENV=production bundle exec rake user:add`

* sendgrid creator user is Sendgrid => can push events to sewc
  so if you adding new server user then chose `no`
* application name that can user access is something like
  `my_server_production`

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
