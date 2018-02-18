//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import Foundation

public struct ConversionRates: Codable {

  public let disclaimer: String
  public let license: String
  public let timestamp: TimeInterval
  public let base: String
  public let rates: [String: Double]

}

