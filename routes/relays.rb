post '/api/relay' do
  body = JSON.parse request.body.read
  relay = Unit.first(:unit => body['unit']).rooms.get(:room => body['room']).roomdata.update(
    :relay_status       => body['relay_status'],
    :updated_at         => DateTime.now
  )
  status 201
  format_response(relay, request.accept)
end
