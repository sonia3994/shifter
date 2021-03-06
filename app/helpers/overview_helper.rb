module OverviewHelper
  def day_of_shift appointment, date
    (date - appointment.starts + 1).to_i
  end
  
  def total_shift_days appointment
    (appointment.ends - appointment.starts + 1).to_i
  end
  
  def next_empty_shift calendar
    if calendar.appointments_today.size == 0
      return "Today"
    elsif calendar.appointments_tomorrow.size == 0
      return "Tomorrow"
    end
    sorted_appts = calendar.appointments_upcoming.sort_by{|appt| appt.starts}
    last_end = Date.tomorrow
    for appt in sorted_appts
      if appt.starts - last_end > 1
        break
      end
      last_end = (last_end > appt.ends ? last_end : appt.ends)
    end
    if last_end < Date.today + 365
      day = last_end + 1
      return day.strftime("%A, %B %-d, %Y") + " (in #{(day - Date.today).to_i} days)"
    end
    return "All covered for the next year"
  end
  
  def next_shifts calendar
    sorted_appts = calendar.appointments_upcoming.sort_by{|appt| appt.starts}
    next_appts = []
    for appt in sorted_appts
      if next_appts.size() > 0 and appt.starts == next_appts[0].starts
        next_appts.append(appt)
      elsif next_appts.size() > 0 and appt.starts != next_appts[0].starts
        break
      elsif appt.starts > Date.today
        next_appts.append(appt)
      end
    end
    return next_appts
  end
  
  def output_shifts calendar, date
    shifts = Array.new
    if date == Date.today
      appointments = calendar.appointments_today
    elsif date == Date.tomorrow
      appointments = calendar.appointments_tomorrow
    else
      appointments = calendar.appointments.includes(:person => :group).on(date)
    end
    appointments.each do |appointment|
      shifts.push(appointment)
    end
  end
end
