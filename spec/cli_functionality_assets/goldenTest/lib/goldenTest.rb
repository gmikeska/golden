require "golden"
class GoldenTest
  def initialize
    libsum = Golden.require("libsum")
    puts libsum.add(1,2) #prints 3
  end
end

gt = GoldenTest.new()
