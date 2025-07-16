require 'pg'

class DB
  def self.connection
    @connection ||= PG.connect(ENV['DATABASE_URL'])
  end

  def self.close_connection
    connection.close
  end

  # Get user info by email
  def self.get_user_info(email)
    connection.exec_params(<<~SQL, [email])
      SELECT display_name, job_title, department, current_year_days_left, project
      FROM users
      WHERE email = $1
    SQL
  end

  # Get next upcoming vacation for a user
  def self.get_next_vacation(email)
    connection.exec_params(<<~SQL, [email])
      SELECT a.start_date, a.end_date
      FROM absences a
      JOIN users u ON a.user_id = u.id
      WHERE u.email = $1 AND a.start_date > NOW()
      ORDER BY a.start_date ASC
      LIMIT 1
    SQL
  end

  # Get previous vacations this year for a user
  def self.get_previous_vacations_this_year(email)
    connection.exec_params(<<~SQL, [email])
      SELECT a.start_date, a.end_date
      FROM absences a
      JOIN users u ON a.user_id = u.id
      WHERE u.email = $1 AND a.start_date >= DATE_TRUNC('year', NOW()) AND a.end_date < NOW()
      ORDER BY a.start_date DESC
    SQL
  end

  # Get all users with the same project
  def self.get_team_members(project)
    connection.exec_params(<<~SQL, [project])
      SELECT display_name, email
      FROM users
      WHERE project = $1 AND deleted_at IS NULL
      ORDER BY display_name
    SQL
  end
end 