module Clients::EventHelper

  def event_detail_address(event)
    [event.try(:venue).try(:address), event.try(:venue).try(:city), event.try(:venue).try(:state)].compact.join(', ') 
  end

  def event_month(event)
  	event.first[0..2]
  end

  def event_date_time(ev)
  	ev.strftime("%B")[0..2]
  end

  def event_show_time(ev)
  	ev.strftime("%I:%M %p")
  end

  def event_odd?(odd, ind)
  	odd && ind > 0 || odd == false
  end

  def event_day_name(event)
  	event.date.strftime("%A, %B %d, %Y")
  end

  def event_door_time(event)
  	event.door_time.strftime("%I:%M %p")
  end

end