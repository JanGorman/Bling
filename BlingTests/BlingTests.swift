//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import XCTest
import Bling

class BlingTests: XCTestCase {

  func testConversion() throws {
    let expectation = self.expectation(description: "Conversion")

    let bling = try makeBling(withFixture: "conversion")

    bling.convert(value: 19999.95, from: "GBP", to: "EUR") { response in
      defer {
        expectation.fulfill()
      }
      switch response {
      case .success(let conversion):
        XCTAssertEqual(conversion.request.from, "GBP")
        XCTAssertEqual(conversion.request.to, "EUR")
      case .failure:
        XCTFail("Missing response")
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func testCurrencies() throws {
    let expectation = self.expectation(description: "Currencies")

    let bling = try makeBling(withFixture: "currencies")

    bling.currencies { response in
      defer {
        expectation.fulfill()
      }
      switch response {
      case .success(let currencies):
        XCTAssertFalse(currencies.isEmpty)
      case .failure:
        XCTFail("Missing response")
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func testHistorical() throws {
    let expectation = self.expectation(description: "Historical")

    let bling = try makeBling(withFixture: "historical")

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
        XCTFail("Missing response")
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func testLatest() throws {
    let expectation = self.expectation(description: "Latest")

    let bling = try makeBling(withFixture: "latest")

    bling.latest { response in
      defer {
        expectation.fulfill()
      }
      switch response {
      case .success(let latest):
        XCTAssertEqual(latest.base, "USD")
        XCTAssertFalse(latest.rates.isEmpty)
      case .failure:
        XCTFail("Missing response")
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func testOHLC() throws {
    let expectation = self.expectation(description: "OHLC")

    let bling = try makeBling(withFixture: "ohlc")

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
        XCTFail("Missing response")
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func testUsage() throws {
    let expectation = self.expectation(description: "Usage")

    let bling = try makeBling(withFixture: "usage")

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
        XCTFail("Missing response")
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func makeBling(withFixture name: String) throws -> Bling {
    let fixture = try loadFixture(named: name)
    MockURLProtocol.requestHandler = { _ in
      return (HTTPURLResponse(), fixture)
    }
    let configuration = MockURLProtocol.mockedURLSessionConfiguration()
    return Bling(appId: "", sessionConfiguration: configuration)
  }

  func loadFixture(named name: String) throws -> Data {
    let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json")!
    return try Data(contentsOf: url)
  }

}
