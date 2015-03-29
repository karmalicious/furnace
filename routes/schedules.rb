# encoding: utf-8
get '/' do
  @units = Unit.all(:unit.not => nil, :order => [ :unit ])
  @schedules = repository(:default).adapter.select("SELECT GROUP_CONCAT(schedules.id) AS id,schedules.start,schedules.stop,schedules.updated_at,schedules.room_id, GROUP_CONCAT(rooms.room ORDER BY rooms.room) AS room, units.id, units.unit FROM schedules INNER JOIN rooms ON schedules.room_id = rooms.id INNER JOIN units ON units.id = rooms.unit_id GROUP BY start,stop ORDER BY unit")
  erb :show_schedules
end

post '/form' do
  @rooms = Unit.get(params[:id]).rooms
  @unit = Unit.get(params[:id]).unit
  erb :create_schedule
end

post '/new' do
  rooms = params[:room]
  rooms.each do |moo|
    Unit.first(:unit => params[:unit]).rooms.first(:room => moo).schedules.create(
      :start		=> params[:start],
      :stop		=> params[:stop],
      :updated_at	=> DateTime.now
    )
  end
  redirect '/'
end

get '/delete/schedules/:id' do
  @schedules = params[:id]
  erb :delete_schedule_confirm
end

get '/delete_confirmed/schedules/:id' do
  id = params[:id].split(",")
  id.each do |line|
    schedule = Schedule.get(line)
    schedule.destroy
  end
  redirect "/"
end

get '/api/schedules' do
  format_response(Schedule.all, request.accept)
end

get '/api/schedules/unit/:unit' do
  schedule ||= Unit.first(:unit => params[:unit]).schedules.all || halt(404)
  format_response(schedule, request.accept)
end

post '/api/schedules' do
  body = JSON.parse request.body.read
  schedule = Schedule.create(
    unit:     body['unit'],
    title:    body['title'],
    start:    body['start'],
    stop:     body['stop']
  )
  status 201
  format_response(schedule, request.accept)
end

put '/api/schedules/:id' do
  body = JSON.parse request.body.read
  schedule ||= Schedule.get(params[:id]) || halt(404)
  halt 500 unless schedule.update(
    unit:     body['unit'],
    title:    body['title'],
    start:    body['start'],
    stop:     body['stop']
  )
  format_response(schedule, request.accept)
end

delete '/api/schedules/:id' do
  schedule ||= Schedule.get(params[:id]) || halt(404)
  halt 500 unless schedule.destroy
end 
