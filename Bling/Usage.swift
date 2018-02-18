//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import Foundation

public enum Status: String, Codable {
  case active
  case restricted = "access_restricted"
}

public struct Usage: Decodable {

  public let status: Status
  public let plan: Plan
  public let requests: Int
  public let quota: Int
  public let remaining: Int
  public let daysElapsed: Int
  public let daysRemaining: Int
  public let dailyAverage: Int

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: RootKeys.self)

    let data = try values.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
    status = try data.decode(Status.self, forKey: .status)
    plan = try data.decode(Plan.self, forKey: .plan)

    let usage = try data.nestedContainer(keyedBy: UsageKeys.self, forKey: .usage)
    requests = try usage.decode(Int.self, forKey: .requests)
    quota = try usage.decode(Int.self, forKey: .quota)
    remaining = try usage.decode(Int.self, forKey: .remaining)
    daysElapsed = try usage.decode(Int.self, forKey: .daysElapsed)
    daysRemaining = try usage.decode(Int.self, forKey: .daysRemaining)
    dailyAverage = try usage.decode(Int.self, forKey: .dailyAverage)
  }

  enum RootKeys: String, CodingKey {
    case data
  }

  enum DataKeys: String, CodingKey {
    case status, plan, usage
  }

  enum UsageKeys: String, CodingKey {
    case requests
    case quota = "requests_quota"
    case remaining = "requests_remaining"
    case daysElapsed = "days_elapsed"
    case daysRemaining = "days_remaining"
    case dailyAverage = "daily_average"
  }

}

public struct Plan: Decodable {

  public let name: String
  public let quota: String
  public let updateFrequency: String
  public let features: Features

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: Keys.self)

    name = try values.decode(String.self, forKey: .name)
    quota = try values.decode(String.self, forKey: .quota)
    updateFrequency = try values.decode(String.self, forKey: .updateFrequency)
    features = try values.decode(Features.self, forKey: .features)
  }

  enum Keys: String, CodingKey {
    case name
    case quota
    case updateFrequency = "update_frequency"
    case features
  }

}

public struct Features: Decodable {

  public let base: Bool
  public let symbols: Bool
  public let experimental: Bool
  public let timeSeries: Bool
  public let convert: Bool
  public let bidAsk: Bool
  public let ohlc: Bool
  public let spot: Bool

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: Keys.self)

    base = try values.decode(Bool.self, forKey: .base)
    symbols = try values.decode(Bool.self, forKey: .symbols)
    experimental = try values.decode(Bool.self, forKey: .experimental)
    timeSeries = try values.decode(Bool.self, forKey: .timeSeries)
    convert = try values.decode(Bool.self, forKey: .convert)
    bidAsk = try values.decode(Bool.self, forKey: .bidAsk)
    ohlc = try values.decode(Bool.self, forKey: .ohlc)
    spot = try values.decode(Bool.self, forKey: .spot)
  }

  enum Keys: String, CodingKey {
    case base
    case symbols
    case experimental
    case timeSeries = "time-series"
    case convert
    case bidAsk = "bid-ask"
    case ohlc
    case spot
  }

}
