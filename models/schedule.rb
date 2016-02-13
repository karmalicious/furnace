class Village
  include DataMapper::Resource
  
  has n, :units, :constraint => :skip

  property :id,		Serial
  property :village,	String
end

class Unit
  include DataMapper::Resource

  belongs_to :village

  has n, :rooms, :constraint => :destroy

  property :id,         Serial
  property :unit,       String
  property :ip,         String
  property :mac,        String
  property :version,    String
end

class Room
  include DataMapper::Resource

  belongs_to :unit

  has n, :schedules, :constraint => :destroy
  
  property :id,         Serial
  property :room,       String
  property :relay_status,	String
  property :temp,		Float
  property :updated_at, 	DateTime
end

class Schedule
  include DataMapper::Resource
  
  belongs_to :room

  property :id,         Serial
  property :start,	DateTime
  property :stop,   	DateTime
  property :updated_at, DateTime
end 
