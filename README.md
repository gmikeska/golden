# Golden [![Gem Version](https://badge.fury.io/rb/golden.svg)](https://badge.fury.io/rb/golden) [![Donate with Bitcoin](https://en.cryptobadges.io/badge/micro/33nyGe6DE2HmnVVn76o9PRrBizSJ5EVfkZ)](https://en.cryptobadges.io/donate/33nyGe6DE2HmnVVn76o9PRrBizSJ5EVfkZ)

## Description

Golden is a development tool that makes it easier to wrap Go libraries for use in Ruby.

## Features

* Usage similar to the every day package manager
* Converts .go files to .so shared libraries
* Manages library exported function metadata in convenient JSON format

## Usage
Building a slightly modified version of the ["libsum.go" example](https://c7.se/go-and-ruby-ffi/)
```go
package main

import "C"

//export add
func add(a int, b int) int {
  return a + b
}
//export subtract
func subtract(a, b int) int { // as of 0.5.2 this shorthand parameter declaration is supported!
  return a - b
}


func main() {}

```
On the command line:
```bash
cd libsum
golden build libsum

cd ../golden-example
golden install libsum
```

Additionally, you can add go libraries built manually or shared by another developer with the `add` command:
```bash
golden add pathToLibraryDirectory
```
or
```bash
golden add pathToLibraryDirectory/golden.json
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

## Donations
[![Donate with Bitcoin](https://en.cryptobadges.io/badge/big/33nyGe6DE2HmnVVn76o9PRrBizSJ5EVfkZ)](https://en.cryptobadges.io/donate/33nyGe6DE2HmnVVn76o9PRrBizSJ5EVfkZ)
