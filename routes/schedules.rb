get '/' do
  @schedules = Schedule.all
  erb :show_schedules
end

get '/form' do
  erb :create_schedule
end

post '/new' do
  Unit.first(:unit => params[:unit]).schedules.create(
    :start	=> params[:start],
    :stop	=> params[:stop],
    :title	=> params[:title],
    :updated_at	=> DateTime.now
  )
  redirect '/'
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
