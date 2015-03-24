use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == "#{LOGIN_USER}" and password == "#{LOGIN_PW}"
end

