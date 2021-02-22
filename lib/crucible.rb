
module Golden
  class Crucible
      attr_accessor :packages, :pkgLogFile
      def initialize(options=nil)
        @pkgLogFile = File.expand_path("~")+"/.golden_packages.json" # Persistent package log
        # @pkgLogFile = File.expand_path(File.dirname(__FILE__)+"/../packages.json") # Gemset specific package log
        # puts "opened package list at #{@pkgLogFile}"
        @options = options
        if(!File.exist?(@pkgLogFile))
          @packages = {}
          self.save()
        else
          @packages = JSON.parse(File.open(@pkgLogFile).read)
        end
      end

      def build(fileName,dir)
        libName,extension = fileName.split('.')
        if(!extension)
          fileName = "#{libName}.go"
        end
        golden_json = "#{dir}/golden.json"
        if(File.exist?(golden_json))
          golden_data = JSON.parse(File.open(golden_json).read)
        else
          golden_data = {}
        end
        path = dir+"/"+fileName
        outfile = "#{libName}.so"
        outpath = dir+"/"+libName
        goVersion = `go version`
        if(!!goVersion)
          if(verbose?)
            puts "detected #{goVersion}"
          end
          # if(File.exist?("#{path}/go.mod")) # Module build procedure
          #   puts "building module at #{path}"
          #   puts "building standard lib"
          #   system("go install -buildmode=shared -linkshared std")
          #   puts "installing dependencies"
          #   deps = system("go mod vendor")
          #   if(!!deps)
          #     puts "linking shared lib for module"
          #     lnk = `go install -buildmode=shared -linkshared #{infile}`
          #     puts lnk
          #     puts "building shared lib for module"
          #     bld = `go build -linkshared -o #{outfile}`
          #     puts bld
          #     system("go build -buildmode=c-shared -o #{outfile} #{fileName}")
          #   end
          # else
            puts "building #{fileName} to shared library #{outfile}"
            system("go build -buildmode=c-shared -o #{outfile} #{fileName}")
          # end
        else
          puts "go not found."
        end
        file = File.open(path)
        source_code = file.read
        exports = source_code.scan(/\/\/\s?export(?<function>.+)/).flatten
        if(verbose?)
          puts "#{fileName} exports the following methods:"
          puts exports
        end

        golden_data[libName] = {}
        exports.each do |e|
          function_name = e.chomp.lstrip
          declaration_regex = Regexp.new("func #{function_name}\s?\((?<args>.*)\) (?<returns>.*) {")
          export_data = {}
          export_data[:args] = {}
          args = source_code.scan(declaration_regex).flatten[0]
          args = args[1,args.length-2]
          args = args.split(',')
          args.each do |arg|
            name, type = arg.split(" ")
            export_data[:args][name] = type
          end
          export_data[:returns] = source_code.scan(declaration_regex).flatten[1]
          # require "pry"
          # binding.pry
          golden_data[libName][function_name] = export_data
        end
        # require "pry"
        # binding.pry
        if(verbose?)
          puts "writing library export info to #{golden_json}"
        end
        File.open(golden_json,"w") do |f|
          f.write(JSON.pretty_generate(golden_data))
        end
        @packages[libName] = dir
      end

      def install(packageName)
        cwd = Dir.pwd
        extDestination = File.expand_path(cwd+"/bin")
        if(!!@packages[packageName])
          if(!File.exist? extDestination)
            Dir.mkdir extDestination
          end

          if(File.exist?(cwd+"/golden.json"))
            golden_json = JSON.parse(File.open(cwd+"/golden.json").read)
            new_package = JSON.parse(File.open(@packages[packageName]+"/golden.json").read)
            golden_json = golden_json.merge(new_package)
            File.open(cwd+"/golden.json","w") do |f|
              f.write(JSON.pretty_generate(golden_json))
            end
          else
            FileUtils.cp(@packages[packageName]+"/golden.json", cwd+"/golden.json")
          end
          FileUtils.cp(@packages[packageName]+"/#{packageName}.so", extDestination+"/#{packageName}.so")
        else
          throw "No such package (#{packageName})."
        end
      end
      def clear
        @packages = {}
        save
      end
      def verbose?
        return (!!@options && !!@options[:verbose])
      end
      def save
        # @pkgLogFile = File.expand_path(File.dirname(__FILE__)+"/../packages.json") # Installation specific package log
        File.open(@pkgLogFile,"w") do |f|
          f.write(JSON.pretty_generate(@packages))
        end
      end
  end
end
