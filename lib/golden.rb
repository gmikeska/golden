require 'ffi'
require 'json'
require "crucible"

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

  def build_struct(struct_data)
    const_definitions = ""
    field_definitions = ""
    struct_template = File.read(File.pwd+"/lib/ffi-struct-template.txt")

    struct_data[:constants].each do |name|
      const_definitions += "\tc.const #{name.to_sym}\n"
    end

    struct_data[:fields].each do |name|
      field_definitions += "\ts.field #{name.to_sym}, #{type.to_sym}\n"
    end

    template_strings = [
      struct_data[:header_file],
      struct_data[:struct_name],
      const_definitions,
      field_definitions
    ]

    template_tokens = [
      "%HEADER_FILENAME%",
      "%STRUCT_NAME%",
      "%CONST_DEFINITIONS%",
      "%FIELD_DEFINITIONS%"
    ]

    template_tokens.each_with_index do |token, i|
      struct_template.gsub!(token, template_strings[i])
    end

    File.open(struct_data[:path],"w") do |f|
      f.write(struct_template)
    end
  end

  module Library
    extend FFI::Library
    def self.new(library_file, exports)
      @types = exports["_types"]
      exports.delete("_types")

      @exports = exports
      @library_file = library_file

      ffi_lib @library_file

      @types.each do |type, old|
        if(!!old)
          typedef old.to_sym, type.to_sym
        else
          typedef :pointer, type.to_sym
        end
      end

      @exports.each do |func, data|
        # puts "attach_function #{func}, #{data["args"]}, #{data["returns"]}"
        attach_function func, data["args"].values.map(&:to_sym), data["returns"].to_sym
      end
      return self
    end
  end
end
