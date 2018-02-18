//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import Foundation

public struct Conversion: Codable {

  public let disclaimer: String
  public let license: String
  public let request: Request
  public let meta: Meta
  public let response: Double

}

public struct Request: Codable {

  public let query: String
  public let amount: Double
  public let from: String
  public let to: String

}

public struct Meta: Codable {

  public let timestamp: TimeInterval
  public let rate: Double

}
