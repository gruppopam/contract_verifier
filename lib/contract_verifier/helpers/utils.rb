module Utils

  def schema_file_name(file_name)
    @stub_root+"/#{file_name}"
  end

  def data_file_name(file_name)
    @data_root+"/#{file_name}"
  end

  def file_present?(file)
    File.file? file and File.exist? file
  end

  def yellow(string)
    "\e[#{33}m#{string}\e[0m"
  end
end
