# encoding: utf-8
get '/' do
  @units = Unit.all(:unit.not => nil, :order => [ :unit ])
  @schedules = Unit.all(:order => :unit.asc).rooms.all(:order => :room).schedules.all(:order => :start.asc )
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
  @schedules = Schedule.get(params[:id])
  erb :delete_confirm
end

get '/delete/schedules/:id/:confirmed/:unit_id' do
  schedule = Schedule.get(params[:id])
  if params[:confirmed] = "ConfirmedDelete"
    schedule.destroy
  end
  redirect "/unit/#{params[:unit_id]}"
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
