configure :development do
  require AppPath.db_setup('local')
  db_setup = LocalDatabaseSetup.new
  ActiveRecord::Base.establish_connection(db_setup)
end

configure :production do
  require AppPath.db_setup('heroku')
  db_setup = HerokuDatabaseSetup.new
  ActiveRecord::Base.establish_connection(db_setup)
end


