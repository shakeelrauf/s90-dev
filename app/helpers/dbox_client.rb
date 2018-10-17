require 'fileutils'

# https://github.com/dropbox/dropbox-sdk-ruby
# http://dropbox.github.io/dropbox-sdk-ruby/api-docs/v1.6.4/
module DboxClient extend ActiveSupport::Concern
  include ErrorCode

  DBOX = ENV["DBOX"]        # The API key

  def get_dropbox_client(key=DBOX)
    begin
      DropboxApi::Client.new(key)
    rescue Exception => e
      puts e.backtrace
      raise e
    end
  end

  def dbox_to_tmp_file(dbox_path, tmp_file_path, client=get_dropbox_client)
    puts "==============> Saving dbox path: #{dbox_path}"
    p = (dbox_path.start_with?('/') ? dbox_path : "/#{dbox_path}")
    begin
      contents = ""
      client.download(p) do |chunk|
        contents << chunk
      end
      open(tmp_file_path, 'wb') {|f| f.puts contents }
    rescue Exception => e
      puts e.backtrace
      raise e
    end
  end

  def tmp_file_to_dbox(tmp_file_path, dbox_path, overwrite=false, client=get_dropbox_client)
    opts = {}
    opts[:mode] = :overwrite if (overwrite)
    p = (dbox_path.start_with?('/') ? dbox_path : "/#{dbox_path}")
    resp = client.upload(p, File.read(tmp_file_path), opts)
    puts "Upload successful. #{resp}"
  end

  def del_from_dbox(dbox_path, client=get_dropbox_client)
    begin
      p = (dbox_path.start_with?('/') ? dbox_path : "/#{dbox_path}")
      client.delete(p)
    rescue
      logger.error "Error: Attempted to delete an unexisting file: #{dbox_path}"
    end
  end

  # def move_dbox_doc(from_path, to_path, client=get_dropbox_client)
  #   puts("Moving document from, to:")
  #   puts(from_path)
  #   puts(to_path)
  #   client.move(from_path, to_path)
  # end
  #
end
