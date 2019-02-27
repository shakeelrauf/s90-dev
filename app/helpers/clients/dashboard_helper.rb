module Clients::DashboardHelper

  def search_records_count(sects)
    sects["artists"].count == 0 && sects["albums"].count == 0 && sects["songs"].count == 0
  end

  def artists_count(sects)
    sects["artists"].count > 0
  end

  def albums_count(sects)
    sects["albums"].count > 0
  end

  def songs_count(sects)
    sects["songs"].count > 0
  end

end