require 'sinatra'
require 'pg'
require 'json'
require 'dotenv/load'

set :port, ENV['PORT'] if ENV['PORT']

post '/user' do
  content_type :json
  request_payload = JSON.parse(request.body.read) rescue {}
  email = request_payload['email']

  halt 400, { error: 'Email is required' }.to_json unless email

  conn = db_connection
  result = conn.exec_params('SELECT * FROM users WHERE email = $1 LIMIT 1', [email])
  user = result.first
  conn.close

  if user
    user.to_json
  else
    halt 404, { error: 'User not found' }.to_json
  end
end 


def db_connection
  PG.connect(ENV['DATABASE_URL'])
end