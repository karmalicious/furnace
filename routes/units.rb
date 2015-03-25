get '/api/units' do
  format_response(Unit.all, request.accept)
end

get '/api/units/:id' do
  unit ||= Unit.get(params[:id]) || halt(404)
  format_response(unit, request.accept)
end

get '/api/units/:unit' do
  unit ||= Unit.all(:unit => params[:unit]) || halt(404)
  format_response(unit, request.accept)
end

post '/api/units' do
  body = JSON.parse request.body.read
  unit = Unit.first_or_create({:unit => body['unit']}).update(
    unit:	body['unit'],
    ip:		body['ip'],
    mac:	body['mac'],
    version:	body['version']
  )
  status 201
  format_response(unit, request.accept)
end

put '/api/units/:id' do
  body = JSON.parse request.body.read
  unit ||= Unit.get(params[:id]) || halt(404)
  halt 500 unless unit.update(
    unit:	body['unit'],
    ip:		body['ip'],
    mac:	body['mac'],
    version:	body['version']
  )
  format_response(unit, request.accept)
end

delete '/api/units/:id' do
  unit ||= Unit.get(params[:id]) || halt(404)
  halt 500 unless unit.destroy
end

get '/units' do
  @units = Unit.all
  erb :test
end

get '/unit/:id' do
  @schedules = Unit.get(params[:id]).schedules.all(:order => :start.asc )
  @title =  Unit.get(params[:id]).unit.capitalize
  erb :show_unit_schedule
end

get '/add_unit' do
  @units = Unit.all(:unit => nil) 
  erb :create_unit
end

post '/new_unit' do
  unit = Unit.get(params[:id])
  unit.update(
    :unit	=> params[:stuga]
  )
  i = 1
  num = params[:room].to_i
  while i <= num  do
  Unit.first(:id => params[:id]).rooms.create(
    :room	=> i
  )
  i += 1
  end
redirect '/'
end
