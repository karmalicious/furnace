class Unit
  include DataMapper::Resource

  has n, :schedules
  has n, :relays
  has n, :temps

  property :id,         Serial
  property :unit,       String
  property :ip,         String
  property :mac,        String
  property :version,    String
end

class Schedule
  include DataMapper::Resource
  
  belongs_to :unit

  property :id,         Serial
  property :title,      String
  property :start,	DateTime
  property :stop,   	DateTime
  property :updated_at, DateTime
end 

class Relay
  include DataMapper::Resource

  belongs_to :unit

  property :id,         	Serial
  property :room,		String
  property :relay_status,	String
  property :updated_at, 	DateTime
end

class Temp
  include DataMapper::Resource

  belongs_to :unit

  property :id,         Serial
  property :room,	Integer
  property :temp,	Float
  property :updated_at, DateTime
end

