module Clients::EventHelper

  def event_detail_address(event)
    [event.try(:venue).try(:address), event.try(:venue).try(:city), event.try(:venue).try(:state)].compact.join(', ') 
  end

end