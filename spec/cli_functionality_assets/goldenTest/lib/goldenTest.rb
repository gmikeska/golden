require "golden"
class GoldenTest
  def initialize
    libsum = Golden.require("libsum")
    g = libsum.person("Greg",37)
    m = libsum.person("Michelle",35)
    puts libsum.add(1,2) #prints 3
  end
end

gt = GoldenTest.new()
