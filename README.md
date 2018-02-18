# Bling 💰

[![Build Status](https://travis-ci.org/JanGorman/Bling.svg?branch=master)](https://travis-ci.org/JanGorman/Bling)

An [Open Exchange Rates](https://openexchangerates.org) API wrapper written in Swift

## Requirements

- Swift 4
- iOS 10.0+
- Xcode 9+

## Install

Bling is available on [Cocoapods](http://cocoapods.org). Add it to your `Podfile` and run `pod install`:

```ruby
pod 'Bling'
```

## Usage

To use Bling you need to create a new instance and pass it your app id:

```swift
let bling = Bling(appId: "…")
bling.latest { response in
  switch response {
  case .success(let latest):
    print(latest.rates)
  case .failure(let error):
    // 😵
  }
}
```

## Tests

Bling uses [Hippolyte](https://github.com/JanGorman/Hippolyte) for stubbing network requests so if you'd like to run the tests yourself, after checking out the repository, run `git submodule init` to fetch the dependency.

## License

Hippolyte is released under the MIT license. See LICENSE for details