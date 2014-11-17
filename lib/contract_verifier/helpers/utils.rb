module ContractVerifier
  module Utils
    include RSpec::Core::Pending


    def data_file_name(file_name)
      @data_root+"/#{file_name}"
    end

    def data_file_name_for(entry, key)
      resource = entry[key]
      response_file = resource['file']
      response_body = resource['body']
      response = response_file || response_body
      if response.nil?
        if entry['request']['method'] == 'GET'
          raise PendingDeclaredInExample.new("No response file defined")
        end
      else
        response_body.nil? ? @data_root+"/#{response_file}" : response_body
      end

    end

    def schema_file_name(entry, key)
      file_name = entry['response']['schema']
      if file_name.nil?
        unless data_file_name_for(entry, key).nil?
          raise PendingDeclaredInExample.new("Schema Undefined/File not present - #{consumer(entry)}")
        end
      else
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
