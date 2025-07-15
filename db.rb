require 'pg'

class DB
  def self.connection
    PG.connect(ENV['DATABASE_URL'])
  end
end 