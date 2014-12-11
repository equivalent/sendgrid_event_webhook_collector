

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
