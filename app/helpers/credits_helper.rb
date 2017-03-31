module CreditsHelper
  def shift_credit(appointment, start_year, end_year)
    starts = appointment.starts
    if (starts.year < start_year.to_i)
      starts = (start_year + "-01-01").to_datetime
    end
    ends = appointment.ends
    if (ends.year > end_year.to_i)
      ends = (end_year + "-12-31").to_datetime
    end
    days = (ends - starts + 1).to_i
    if appointment.calendar.no_credit_day
      days -= 1
    end
    return days.to_f / appointment.calendar.days_per_credit
  end

  def sum_credits(group, start_year, end_year)
    total_credits = 0
    group.appointments.inyears(start_year, end_year).started.incals(@cals_to_show).forcredit.each do |shift|
      total_credits += shift_credit shift, start_year, end_year
    end
    return total_credits.round(2)
  end
  
  def scheduled_credits(group, start_year, end_year)
    total_credits = 0
    group.appointments.inyears(start_year, end_year).scheduled.incals(@cals_to_show).forcredit.each do |shift|
      total_credits += shift_credit shift, start_year, end_year
    end
    return total_credits.round(2)
  end
    
  def list_cals_to_show
    if @cals_to_show.size > 0 and @cals_to_show.size < @calendars.size
      return @cals_to_show.map(&:title).to_sentence
    else
      return "all calendars"
    end
  end
end
