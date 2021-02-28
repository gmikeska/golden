buildTestDirectory = File.expand_path "./spec/cli_functionality_assets/go-libsum"
installTestDirectory = File.expand_path "./spec/cli_functionality_assets/goldenTest"
require 'json'
require_relative '../lib/crucible'
RSpec.describe 'cli' do

  it 'should build a library' do
    Dir.chdir(buildTestDirectory)
    expect { system %(golden build libsum) }
     .to output(a_string_including("building libsum.go to shared library libsum.so"))
     .to_stdout_from_any_process
  end

  it 'should install a built library' do
    Dir.chdir(installTestDirectory)
    expect { system %(golden install libsum) }
     .to output(a_string_including("installing libsum."))
     .to_stdout_from_any_process
  end

  it 'should list known libraries' do
    expect { system %(golden list) }
     .to output(a_string_including("Golden has access to the following libraries:"))
     .to_stdout_from_any_process
    expect { system %(golden list) }
     .to output(a_string_including("libsum"))
     .to_stdout_from_any_process
  end

  it 'should not list libraries when cleared' do
    system %(golden clear -f)
    expect { system %(golden list) }
     .to output(a_string_including("No libraries have yet been built. Navigate to a go project and build one using 'golden build (LibraryName).'"))
     .to_stdout_from_any_process
  end

  it 'should add an existing library' do
    Dir.chdir(buildTestDirectory)
    system %(golden clear -f)
    system %(golden add .)
    expect { system %(golden list) }
     .to output(a_string_including("libsum"))
     .to_stdout_from_any_process
  end

end
