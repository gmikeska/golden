require 'json'
require_relative '../lib/crucible'

RSpec.describe 'crucible' do

  it 'should reference a package' do
    buildTestDirectory = File.expand_path "./spec/cli_functionality_assets/go-libsum"
    Dir.chdir(buildTestDirectory)
    system %(golden build libsum) # Build libsum to ensure the cache has a package to show.

    crucible = Golden::Crucible.new
    expect(crucible.packages.keys.length).to eq(2)
  end

  it 'should hold configs' do
    crucible = Golden::Crucible.new
    expect(crucible.packages["_config"]).to be_truthy
  end

  it 'should set configs' do
    crucible = Golden::Crucible.new
    crucible.config("test_config",true)
    crucible.save
    crucible = Golden::Crucible.new
    expect(crucible.packages["_config"]["test_config"]).to eq(true)
    crucible.unset_config("test_config")
    crucible.save
  end

  it 'should get configs' do
    crucible = Golden::Crucible.new
    crucible.config("test_config",true)
    crucible.save
    crucible = Golden::Crucible.new
    expect(crucible.get_config("test_config")).to eq(true)
  end

  it 'should unset configs' do
    crucible = Golden::Crucible.new
    crucible.config("test_config",true)
    crucible.save
    crucible = Golden::Crucible.new
    crucible.unset_config("test_config")
    expect(crucible.get_config("test_config")).to eq(nil)
  end

end
