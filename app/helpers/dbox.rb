class Dbox
  include DboxClient

  attr_accessor :api_key

  def initialize(api_key)
  	self.api_key = api_key
  end

  def to_tmp_file(dbox_path, tmp_file_path)
  	dbox_to_tmp_file(dbox_path, tmp_file_path, get_dropbox_client(api_key))
  end

  def tmp_file_to(tmp_file_path, dbox_path)
  	tmp_file_to_dbox(tmp_file_path, dbox_path, true, get_dropbox_client(self.api_key))
  end
end