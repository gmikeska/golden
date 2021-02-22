require 'json'
require_relative '../lib/crucible'

RSpec.describe 'crucible' do

  it 'should reference a package' do
    buildTestDirectory = File.expand_path "./spec/cli_functionality_assets/go-libsum"
    Dir.chdir(buildTestDirectory)
    system %(golden build libsum) # Build libsum to ensure the cache has a package to show.

    crucible = Golden::Crucible.new
    expect(crucible.packages.keys.length).to eq(1)
  end

end
