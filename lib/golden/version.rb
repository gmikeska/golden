require 'rubygems'
module Golden
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end
  module VERSION
    MAJOR = 0
    FEATURE = 6
    PATCH  = 0
    PRE   = "0"
    if(PRE && PRE != "0")
      STRING = [MAJOR, FEATURE, PATCH, PRE].compact.join(".")
    else
      STRING = [MAJOR, FEATURE, PATCH].compact.join(".")
    end
  end
end
