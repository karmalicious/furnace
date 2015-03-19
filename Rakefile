require 'dm-migrations'

desc "List all routes for this application"
task :routes do
  puts `grep '^[get|post|put|delete].*do$' routes/*.rb | sed 's/ do$//'`
end

desc "auto migrates the database"
task :migrate do
  require './heat'
  DataMapper.auto_migrate!
end

desc "auto upgrades the database"
task :upgrade do
  require './heat'
  DataMapper.auto_upgrade!
end

