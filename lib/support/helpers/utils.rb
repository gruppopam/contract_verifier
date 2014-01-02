module Utils

  def schema_file_name(file_name)
    @stub_root+"/#{file_name}"
  end

  def data_file_name(file_name)
    @stub_root+'/'+file_name
  end

  def file_present?(file)
    File.exist? file
  end
end
