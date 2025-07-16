class MyNextVacation
  def self.call(context)
    email = context["email"]

    result = DB.get_next_vacation(email)

    absence = result.first
    if absence
      { message: "Your next vacation starts on #{DateFormatter.format(absence['start_date'])} and ends on #{DateFormatter.format(absence['end_date'])}." }
    else
      { message: "No upcoming vacations found." }
    end
  end
end