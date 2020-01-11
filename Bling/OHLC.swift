//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import Foundation

public struct OHLC: Decodable {

  public let disclaimer: String
  public let license: String
  public let startTime: Date
  public let endTime: Date
  public let base: String
  public let rates: [String: Rate]

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: Keys.self)

    disclaimer = try values.decode(String.self, forKey: .disclaimer)
    license = try values.decode(String.self, forKey: .license)
    startTime = try values.decode(Date.self, forKey: .startTime)
    endTime = try values.decode(Date.self, forKey: .endTime)
    base = try values.decode(String.self, forKey: .base)
    rates = try values.decode([String: Rate].self, forKey: .rates)
  }

  enum Keys: String, CodingKey {
    case disclaimer
    case license
    case startTime = "start_time"
    case endTime = "end_time"
    case base
    case rates
  }

}

public struct Rate: Decodable {

  public let open: Double
  public let high: Double
  public let low: Double
  public let close: Double
  public let average: Double

}
