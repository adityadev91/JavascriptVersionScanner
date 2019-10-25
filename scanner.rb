#!/usr/bin/env ruby
require 'pp'
require_relative "environment_variables"

module JSLibraryScanner
  class ScannerUtils
    def self.run
      parse_list_of_js_file_paths
    end

    def self.get_list_of_js_file_paths
      Dir.glob($JS_PATH)
    end

    def self.parse_list_of_js_file_paths
      list_of_js_file_paths = get_list_of_js_file_paths
      list_of_js_file_paths.map { |js_file_path|
        puts js_file_path.split("/")[-1]
        js_file_content = File.open(js_file_path).read
        js_file_content.each_line do |line|
          if line.downcase.include? "version" # and (line.include? ":" or line.include? "=")
            version = line.scan(/\d+\.[a-z0-9]+\.[a-z0-9|-]+/)
            if version.length > 0
              puts version
            else
              puts "This JS file probably contains the version number that cannot be parsed with your current regex. Please update your RegExp pattern"
            end
          end
        end
        puts ""
      }
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  JSLibraryScanner::ScannerUtils.run
end
