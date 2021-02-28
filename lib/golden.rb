require 'ffi'
require 'json'
require "crucible"
require_relative("golden/version")
module Golden
  def self.require(library)
    golden_data = self.load
    return self::Library.new(File.expand_path("./bin/#{library}.so"),golden_data[library])
  end
  def self.load
    golden_json = File.expand_path(Dir.pwd()+"/golden.json")
    if(!!File.exist?(golden_json))
      golden_data = JSON.parse(File.open(golden_json).read)
    else
      throw "golden.json not found."
    end
    return golden_data
  end
  module Library
    extend FFI::Library
    def self.new(library_file, exports)
      @exports = exports
      @library_file = library_file
      ffi_lib @library_file
      @exports.each do |func, data|
        # puts "attach_function #{func}, #{data["args"]}, #{data["returns"]}"
        attach_function func, data["args"].values.map(&:to_sym), data["returns"].to_sym
      end
      return self
    end
  end
end
