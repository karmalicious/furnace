get '/api/units' do
  unit ||= Unit.all || halt(404) 
  format_response(unit, request.accept)
end

post '/api/units' do
  body = JSON.parse request.body.read
  village = Village.first_or_create( :village => 'Ogrupperade')
  unit = Unit.first_or_create({:mac => body['mac']}, {
    :ip		=>	body['ip'],
    :version	=>	body['version'],
    :village_id =>	village['id']
  })
  status 201
  format_response(unit, request.accept)
end

get '/api/units/data/:mac' do
  hostname ||= Unit.first(:mac => params[:mac]).unit || halt(404)
  format_response(hostname, request.accept)
end

get '/api/units/rooms/:mac' do
  rooms ||= Unit.first(:mac => params[:mac]).rooms.count || halt(404)
  format_response(rooms, request.accept)
end

get '/unit/:id' do
  id = params[:id]
  @schedules = repository(:default).adapter.select("SELECT GROUP_CONCAT(schedules.id) AS id,schedules.start,schedules.stop,schedules.updated_at,schedules.room_id, GROUP_CONCAT(rooms.room ORDER BY rooms.room) AS room FROM schedules INNER JOIN rooms ON schedules.room_id = rooms.id INNER JOIN units ON units.id = rooms.unit_id WHERE units.id = '#{id}' GROUP BY start,stop")
  @title =  Unit.get(params[:id]).unit.capitalize
  @rooms = Unit.get(params[:id]).rooms.all
  erb :show_unit
end

get '/add_unit' do
  @units = Unit.all(:unit => nil) 
  @villages = Village.all(:order => :village)
  erb :create_unit
end

get '/add_village' do
  erb :add_village
end

post '/new_unit' do
  Unit.first(params[:id]).update(
    :unit	=> params[:stuga],
    :village_id	=> params[:village],
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

post '/new_village' do
  Village.first_or_create(
    :village	=> params[:village]
  )
  redirect '/'
end

get '/delete_unit' do
  @units = Unit.all(:unit.not => nil)
  erb :delete_unit
end

post '/delete/unit' do
  @unit = Unit.get(params[:id])
  erb :delete_unit_confirm
end

get '/delete_confirmed/unit/:id' do
  unit = Unit.get(params[:id])
  unit.destroy
  redirect "/"
end

get '/admin' do
  erb :admin
end
