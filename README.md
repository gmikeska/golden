# Golden

## Description

Golden is a development tool that makes it easier to wrap Go libraries for use in Ruby.

## Features

* Usage similar to the every day package manager
* Converts .go files to .so shared libraries
* Manages library exported function metadata in convenient JSON format

## Usages
On the command line (building the ["libsum.go" example](https://c7.se/go-and-ruby-ffi/))
```bash
cd libsum
golden build libsum

cd ../golden-example
golden install libsum
```
Then, reference the library in your ruby project:
```ruby
require "golden"

class GoldenExample
  def initialize
    libsum = Golden.require("libsum")
    puts libsum.add(1,2) #prints 3
  end
end

```

## Installation

From rubygems:

    [sudo] gem install golden

or from the git repository on github:

    git clone git://github.com/gmikeska/golden.git
    cd golden
    bundle install
    rake install

## License

Golden is covered by the BSD license, also see the LICENSE file.
The specs are covered by the same license as [ruby/spec](https://github.com/ruby/spec), the MIT license.
