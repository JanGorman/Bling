//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import Foundation

public enum Result<T> {
  case success(T)
  case failure(Error)

  init(value: T?, error: Error?) {
    switch (value, error) {
    case (let value?, _):
      self = .success(value)
    case (nil, let error?):
      self = .failure(error)
    case (nil, nil):
      let error = NSError(domain: "com.schnaub", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Value and error are both nil"])
      self = .failure(error)
    }
  }

}
