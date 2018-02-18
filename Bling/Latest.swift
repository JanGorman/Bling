//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import Foundation

public struct Conversion: Codable {

  let disclaimer: String
  let license: String
  let timestamp: TimeInterval
  let base: String
  let rates: [String: Double]

}
