class Unit
  include DataMapper::Resource

  has n, :rooms

  property :id,         Serial
  property :unit,       String
  property :ip,         String
  property :mac,        String
  property :version,    String
end

class Room
  include DataMapper::Resource

  belongs_to :unit

  has 1, :relay
  has 1, :temp
  has n, :schedules
  
  property :id,         Serial
  property :room,       String
end

class Schedule
  include DataMapper::Resource
  
  has n, :rooms 	

  property :id,         Serial
  property :title,      String
  property :start,	DateTime
  property :stop,   	DateTime
  property :updated_at, DateTime
end 

class Relay
  include DataMapper::Resource

  belongs_to :room

  property :id,         	Serial
  property :relay_status,	String
  property :updated_at, 	DateTime
end

class Temp
  include DataMapper::Resource

  belongs_to :room

  property :id,         Serial
  property :temp,	Float
  property :updated_at, DateTime
end

