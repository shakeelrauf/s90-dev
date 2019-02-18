class Person::Artist < Person::Person
  has_one  :search_index, inverse_of: :artist, class_name: "SearchIndex"
  after_save :on_after_save
  has_many :tours, inverse_of: :artist, class_name: "Tour", foreign_key: :artist_id

  def as_json(options = { })
    super(:only => [:first_name, :last_name]).merge({
      :oid=>self.oid
    })
  end

  # Used in to_json
  def oid
    self.id.to_s
  end

  def on_after_save
    reindex
  end

  def reindex
    self.search_index = SearchIndex.new if (self.search_index.nil?)
    self.search_index.artist = self
    self.search_index.l = self.name
    self.search_index.s = self.name
    self.search_index.r = 2
    self.search_index.is_suspended =  self.is_suspended
    self.search_index.a = {"pic": self.profile_pic_url } if (self.search_index.a.nil?) and (self.profile_pic_name.present?)
    self.search_index.save!
    puts "=====> Reindexing: #{self.inspect}"
    puts "=====>             #{self.search_index.inspect}"
  end

end
