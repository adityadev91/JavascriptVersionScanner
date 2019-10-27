#!/usr/bin/env ruby
require 'pp'
require_relative "environment_variables"

module JSLibraryScanner
  class ScannerUtils
    def self.run
      hash_library_version = get_versions_of_js_libraries
      pp hash_library_version
    end

    def self.get_list_of_js_file_paths
      Dir.glob($JS_PATH)
    end

    def self.get_versions_of_js_libraries
      list_of_js_file_paths = get_list_of_js_file_paths
      parse_js_file_content(list_of_js_file_paths)
    end

    def self.get_file_name(file_path)
      file_path.split("/")[-1]
    end

    def self.parse_js_file_content(file_paths)
      hash_library_version = Hash.new("")
      file_paths.map do |file_path|
        js_file_content = get_file_content(file_path)
        file_name = get_file_name(file_path)
        hash_library_version[file_name] = get_version_from_file_content(js_file_content)
      end
      hash_library_version
    end

    def self.get_version_from_file_content(file_content)
      list_of_versions = []
      file_content.each_line do |line|
        if line.downcase.include? "version"
          version = line.scan(/\d+\.[a-z0-9]+\.[a-z0-9|-]+/)
          if version.length > 0
            list_of_versions.push version
          else
            list_of_versions.push "Probably better regexp needed?"
          end
        end
      end
      list_of_versions
    end

    def self.get_file_content(file_path)
      File.open(file_path).read
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  JSLibraryScanner::ScannerUtils.run
end
