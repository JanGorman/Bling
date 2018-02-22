# Bling 💰

[![Build Status](https://travis-ci.org/JanGorman/Bling.svg?branch=master)](https://travis-ci.org/JanGorman/Bling)
[![codecov](https://codecov.io/gh/JanGorman/Bling/branch/master/graph/badge.svg)](https://codecov.io/gh/JanGorman/Bling)
[![Version](https://img.shields.io/cocoapods/v/Bling.svg?style=flat)](http://cocoapods.org/pods/Bling)
[![License](https://img.shields.io/cocoapods/l/Bling.svg?style=flat)](http://cocoapods.org/pods/Bling)
[![Platform](https://img.shields.io/cocoapods/p/Bling.svg?style=flat)](http://cocoapods.org/pods/Bling)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

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