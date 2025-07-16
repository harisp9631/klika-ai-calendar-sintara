class MyTeamsVacations
  def self.call(context)
    email = context["email"]

    # Get user's project
    user_result = DB.get_user_info(email)
    project = user_result.first['project']
    
    # Get all users with the same project (excluding current user)
    team_result = DB.get_team_members(project)

    # Get next vacation for each team member
    response = []
    response << "Team Vacations for Project: #{project}"
    response << ""

    team_result.each do |member|
      # Skip current user
      next if member['email'] == email
      
      # Get next vacation for this team member
      vacation_result = DB.get_next_vacation(member['email'])

      vacation = vacation_result.first
      if vacation
        response << "#{member['display_name']}: #{DateFormatter.format(vacation['start_date'])} to #{DateFormatter.format(vacation['end_date'])}"
      else
        response << "#{member['display_name']}: No upcoming vacations"
      end
    end

    { message: response.join("\n") }
  end
end 