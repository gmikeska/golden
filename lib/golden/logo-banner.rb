require 'tty-font'
module Golden
  module Logo
    def self.build
      require 'pastel'
      pastel = Pastel.new
      font = TTY::Font.new("standard")
      return pastel.yellow(font.write("Golden"))
    end
  end
end
