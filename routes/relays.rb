post '/api/relay' do
  body = JSON.parse request.body.read
  relay = Unit.first(:unit => body['unit']).relays.first_or_create({
    :room               => body['room']}).update(
    :room               => body['room'],
    :relay_status       => body['relay_status'],
    :updated_at         => DateTime.now
  )
  status 201
  format_response(relay, request.accept)
end

