
module Golden
  class Crucible
      attr_accessor :packages
      def initialize
        @pkgLogFile = File.expand_path("~")+"/.golden_packages.json" # Persistent package log
        # @pkgLogFile = File.expand_path(File.dirname(__FILE__)+"/../packages.json") # Installation specific package log
        # puts "opened package list at #{@pkgLogFile}"
        if(!File.exist?(@pkgLogFile))
          @packages = {}
          self.save()
        else
          @packages = JSON.parse(File.open(@pkgLogFile).read)
        end
      end

      def save
        # @pkgLogFile = File.expand_path(File.dirname(__FILE__)+"/../packages.json") # Installation specific package log
        File.open(@pkgLogFile,"w") do |f|
          f.write(JSON.pretty_generate(@@packages))
        end
      end
  end
end
