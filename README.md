# Bling 💰

![CI](https://github.com/JanGorman/Bling/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/JanGorman/Bling/branch/master/graph/badge.svg)](https://codecov.io/gh/JanGorman/Bling)
[![Version](https://img.shields.io/cocoapods/v/Bling.svg?style=flat)](http://cocoapods.org/pods/Bling)
[![License](https://img.shields.io/cocoapods/l/Bling.svg?style=flat)](http://cocoapods.org/pods/Bling)
[![Platform](https://img.shields.io/cocoapods/p/Bling.svg?style=flat)](http://cocoapods.org/pods/Bling)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

An [Open Exchange Rates](https://openexchangerates.org) API wrapper written in Swift using Combine.

## Requirements

- Swift 5.1
- iOS 13.0+

## Install

Bling is available on [Cocoapods](http://cocoapods.org). Add it to your `Podfile` and run `pod install`:

```ruby
pod 'Bling'
```

## Usage

To use Bling you need to create a new instance and pass it your app id:

```swift
let bling = Bling(appId: "…")

bling.latest()
  .sink(receiveCompletion: { _ in },
        receiveValue: { print($0) })
  .store(in: &subscriptions)
```

## License

Bling is released under the MIT license. See LICENSE for details
