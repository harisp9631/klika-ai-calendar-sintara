class MyGeneralInfo
  def self.call(context)
    email = context["email"]

    # Get user info
    user_result = DB.get_user_info(email)

    # Get next upcoming vacation
    next_vacation_result = DB.get_next_vacation(email)

    # Get previous vacations this year
    previous_vacations_result = DB.get_previous_vacations_this_year(email)

    user = user_result.first
    next_vacation = next_vacation_result.first
    previous_vacations = previous_vacations_result.to_a

    response = []
    response << "Name: #{user['display_name']}"
    response << "Job Title: #{user['job_title']}"
    response << "Department: #{user['department']}"
    response << "Remaining Vacation Days: #{user['current_year_days_left']}"
    
    if next_vacation
      response << "Next Vacation: #{DateFormatter.format(next_vacation['start_date'])} to #{DateFormatter.format(next_vacation['end_date'])}"
    else
      response << "Next Vacation: No upcoming vacations scheduled"
    end
    
    if previous_vacations.any?
      response << "Previous Vacations This Year:"
      previous_vacations.each do |vacation|
        response << "  - #{DateFormatter.format(vacation['start_date'])} to #{DateFormatter.format(vacation['end_date'])}"
      end
    else
      response << "Previous Vacations This Year: None"
    end

    { message: response.join("\n") }
  end
end
