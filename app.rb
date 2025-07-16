require 'sinatra'
require 'pg'
require 'json'
require 'dotenv/load'
require 'openai'
require_relative 'db'
require_relative 'functions/my_next_vacation'
require_relative 'functions/my_general_info'
require_relative 'functions/my_teams_vacations'

set :port, ENV['PORT'] if ENV['PORT']

post '/ai-function' do
  content_type :json
  request_payload = JSON.parse(request.body.read) rescue {}
  context = request_payload['Context'] || request_payload['context']
  prompt = request_payload['prompt']

  halt 400, { error: 'Context and prompt are required' }.to_json unless context && prompt

  openai_client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])

  system_prompt = <<~PROMPT
    You are an intelligent function router. Given a user's context and prompt, decide which of the following functions should be called:
    - my_next_vacation
    - my_general_info
    - my_teams_vacations
    Only return the function name as a string, nothing else.
  PROMPT

  messages = [
    { role: "system", content: system_prompt },
    { role: "user", content: "Context: #{context}, prompt: #{prompt}" }
  ]

  response = openai_client.chat.completions.create(
    messages: messages,
    model: "gpt-4.1"
  )

  function_name = response.choices[0][:message][:content]&.strip

  function_map = {
    "my_next_vacation" => MyNextVacation,
    "my_general_info" => MyGeneralInfo,
    "my_teams_vacations" => MyTeamsVacations
  }

  if function_name && function_map[function_name]
    result = function_map[function_name].call(context)
  else
    result = { message: "Could not determine function" }
  end

  result[:message]
end

def db_connection
  PG.connect(ENV['DATABASE_URL'])
end