//
//  Copyright © 2020 Schnaub. All rights reserved.
//

import Foundation

extension URLSessionConfiguration {
  static func withFixture(_ fixture: String) -> URLSessionConfiguration {
    func loadFixture(_ fixture: String) -> Data? {
      Bundle(for: BundleToken.self)
        .path(forResource: fixture, ofType: "json")
        .map(URL.init(fileURLWithPath:))
        .flatMap { try? Data(contentsOf: $0) }
    }

    final class MockURLProtocol: URLProtocol {

      static var loadFixture: (() -> Data?)!

      override class func canInit(with request: URLRequest) -> Bool {
        true
      }

      override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
      }

      override func startLoading() {
        client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.loadFixture()!)
        client?.urlProtocolDidFinishLoading(self)
      }

      override func stopLoading() {}
    }

    MockURLProtocol.loadFixture = { loadFixture(fixture) }

    let configuration: URLSessionConfiguration = .ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return configuration
  }

  static var failed: URLSessionConfiguration {
    final class MockURLProtocol: URLProtocol {
      override class func canInit(with request: URLRequest) -> Bool {
        true
      }

      override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
      }

      override func startLoading() {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
        client?.urlProtocol(self, didFailWithError: error)
      }

      override func stopLoading() {}
    }

    let configuration: URLSessionConfiguration = .ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return configuration
  }
}

private final class BundleToken {}
