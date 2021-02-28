require 'rubygems'
module Golden
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end
  def self.update_available? # Returns true if update is required
    current = Gem.latest_version_for("golden").segments
    if((VERSION::MAJOR < current[0]) || (VERSION::FEATURE < current[1]) || (VERSION::PATCH < current[2]))
      return current
    end
  end
  module VERSION
    MAJOR = 0
    FEATURE = 6
    PATCH  = 1
    PRE   = "0"
    if(PRE && PRE != "0")
      STRING = [MAJOR, FEATURE, PATCH, PRE].compact.join(".")
    else
      STRING = [MAJOR, FEATURE, PATCH].compact.join(".")
    end
  end
end
