module DateFormatter
  def self.format(date_string)
    return date_string unless date_string
    Date.parse(date_string).strftime("%d.%m.%Y")
  rescue
    date_string
  end
end 