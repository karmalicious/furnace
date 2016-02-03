require 'json'
require 'sinatra'
require 'data_mapper'
require 'dm-migrations'
require './environment'

set :bind, '0.0.0.0'
set :port, '80'

configure :development do
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(
    :default,
    "mysql://vassaro:#{DBPW}@localhost/schedule"
  )
end

require './models/init'
require './helpers/init'
require './routes/init'
DataMapper.finalize
