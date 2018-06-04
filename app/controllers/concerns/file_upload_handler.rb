module FileUploadHandler
  include DboxClient

  def upload_internal(file_owner)
    client = get_dropbox_client
    f = file_owner.up_file
    cursor = client.upload_session_start(File.read(f.path))
    client.upload_session_finish(cursor, {"path"=>file_owner.dbox_path})
  end

  # chunk: 0: the first chunk, 1: intermediate, 2: final, nil: no chunks
  def upload_internal_multi(file_objects)

    if (request.post?)

      file_objects.each do |obj|
        f = obj.file
        cursor = client.upload_session_start(File.read(f.path))
        client.upload_session_finish(cursor, {"path"=>obj.dbox_path})
      end
    end
  end

end
