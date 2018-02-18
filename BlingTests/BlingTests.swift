//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import XCTest
import Bling
import Hippolyte

class BlingTests: XCTestCase {

  let bling = Bling(appId: "")
  
  override func setUp() {
    super.setUp()
    Hippolyte.shared.start()
  }

  override func tearDown() {
    Hippolyte.shared.clearStubs()
    super.tearDown()
  }

  func testConversion() throws {
    let expectation = self.expectation(description: "Conversion")

    try addStubbedRequest(withFixture: "conversion")

    bling.convert(value: 19999.95, from: "GBP", to: "EUR") { response in
      defer {
        expectation.fulfill()
      }
      switch response {
      case .success(let conversion):
        XCTAssertEqual(conversion.request.from, "GBP")
        XCTAssertEqual(conversion.request.to, "EUR")
      case .failure:
        XCTFail()
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func testCurrencies() throws {
    let expectation = self.expectation(description: "Currencies")

    try addStubbedRequest(withFixture: "currencies")

    bling.currencies { response in
      defer {
        expectation.fulfill()
      }
      switch response {
      case .success(let currencies):
        XCTAssertFalse(currencies.isEmpty)
      case .failure:
        XCTFail()
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func testHistorical() throws {
    let expectation = self.expectation(description: "Historical")

    try addStubbedRequest(withFixture: "historical")

    let date = Date(timeIntervalSince1970: 982281601)

    bling.historical(date: date) { response in
      defer {
        expectation.fulfill()
      }
      switch response {
      case .success(let historical):
        XCTAssertEqual(historical.base, "USD")
        XCTAssertFalse(historical.rates.isEmpty)
      case .failure:
        XCTFail()
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func testLatest() throws {
    let expectation = self.expectation(description: "Latest")

    try addStubbedRequest(withFixture: "latest")

    bling.latest { response in
      defer {
        expectation.fulfill()
      }
      switch response {
      case .success(let latest):
        XCTAssertEqual(latest.base, "USD")
        XCTAssertFalse(latest.rates.isEmpty)
      case .failure:
        XCTFail()
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func testOHLC() throws {
    let expectation = self.expectation(description: "OHLC")

    try addStubbedRequest(withFixture: "ohlc")

    let date = Date(timeIntervalSince1970: 1500289200)

    bling.ohlc(startTime: date, period: "30m", symbols: "GBP", "EUR", "HKD") { response in
      defer {
        expectation.fulfill()
      }
      switch response {
      case .success(let ohlc):
        XCTAssertEqual(ohlc.base, "USD")
        XCTAssertFalse(ohlc.rates.isEmpty)
        XCTAssertNotNil(ohlc.rates["EUR"])
      case .failure:
        XCTFail()
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func testUsage() throws {
    let expectation = self.expectation(description: "Usage")

    try addStubbedRequest(withFixture: "usage")

    bling.usage { response in
      defer {
        expectation.fulfill()
      }
      switch response {
      case .success(let usage):
        XCTAssertEqual(usage.status, .active)
        XCTAssertFalse(usage.plan.features.base)
        XCTAssertEqual(usage.requests, 7)
        XCTAssertEqual(usage.quota, 1_000)
      case .failure:
        XCTFail()
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func addStubbedRequest(withFixture name: String) throws {
    let fixture = try loadFixture(named: name)
    let response = StubResponse.Builder().stubResponse(withStatusCode: 200).addBody(fixture).build()
    let regex = try NSRegularExpression(pattern: "https://openexchangerates.org/api/+", options: [])
    let matcher = RegexMatcher(regex: regex)
    let request = StubRequest.Builder().stubRequest(withMethod: .GET, urlMatcher: matcher).addResponse(response).build()
    Hippolyte.shared.add(stubbedRequest: request)
  }

  func loadFixture(named name: String) throws -> Data {
    let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json")!
    return try Data(contentsOf: url)
  }

}
