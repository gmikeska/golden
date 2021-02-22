buildTestDirectory = File.expand_path "./spec/cli_functionality_assets/go-libsum"
installTestDirectory = File.expand_path "./spec/cli_functionality_assets/goldenTest"
require "golden"
cwd = Dir.pwd
RSpec.describe 'golden' do
  it 'should load required libraries' do
    # buildTestDirectory = "./spec/cli_functionality_assets/go-libsum"
    Dir.chdir(buildTestDirectory)
    system %(golden build libsum) # Ensure libsum is built.

    Dir.chdir(installTestDirectory) # step into install directory to ensure Golden can see golden.json
    libsum = Golden.require("libsum")
    expect(libsum.add(1,2)).to eq(3)
  end
end
