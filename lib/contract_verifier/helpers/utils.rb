module ContractVerifier
  module Utils
    include RSpec::Core::Pending


    def data_file_name(file_name)
      @data_root+"/#{file_name}"
    end

    def data_file_name_for(entry, key)
      response_file = entry[key]['file']
      response_body = entry[key]['body']
      response = response_file || response_body
      if response.nil?
        if entry['request']['method'] == 'GET'
          raise "Data Undefined/File not present - #{consumer(entry)}"
        end
      else
        response_body.nil? ? @data_root+"/#{response_file}" : response_body
      end
    end

    def schema_file_name(entry, key)
      file_name = entry['response']['schema']
      unless file_name.nil?
        @stub_root+"/#{file_name}"
      end
    end

    def schema_name(file_name)
      @stub_root+"/#{file_name}"
    end

    def consumer(entry)
      url = entry['request']['url']
      method = entry['request']['method']
      "#{method} of #{url}"
    end

    def file_present?(file)
      File.file? file and File.exist? file
    end

    def yellow(string)
      "\e[#{33}m#{string}\e[0m"
    end

    def red(string)
      "\e[#{31}m#{string}\e[0m"
    end
  end
end
