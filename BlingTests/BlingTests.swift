//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import XCTest
import Bling
import Combine

final class BlingTests: XCTestCase {

  private var subscriptions: Set<AnyCancellable> = []

  override func tearDown() {
    subscriptions.removeAll()
  }

  func testConversion() throws {
    let expectation = self.expectation(description: #function)
    let bling = try makeBling(withFixture: "conversion")
    var result: Conversion!

    bling.convert(value: 19_999.95, from: "GBP", to: "EUR")
      .sink(receiveCompletion: { _ in expectation.fulfill() },
            receiveValue: { result = $0 })
      .store(in: &subscriptions)

    waitForExpectations(timeout: 1, handler: nil)

    XCTAssertEqual(result.request.from, "GBP")
    XCTAssertEqual(result.request.to, "EUR")
  }

  func testCurrencies() throws {
    let expectation = self.expectation(description: #function)
    let bling = try makeBling(withFixture: "currencies")
    var result: [String: String]!

    bling.currencies()
      .sink(receiveCompletion: { _ in expectation.fulfill()},
            receiveValue: { result = $0 })
      .store(in: &subscriptions)

    waitForExpectations(timeout: 1, handler: nil)

    XCTAssertFalse(result.isEmpty)
  }

  func testHistorical() throws {
    let expectation = self.expectation(description: #function)
    let bling = try makeBling(withFixture: "historical")
    var result: ConversionRates!

    let date = Date(timeIntervalSince1970: 982281601)

    bling.historical(date: date)
      .sink(receiveCompletion: { _ in expectation.fulfill()},
            receiveValue: { result = $0 })
      .store(in: &subscriptions)

    waitForExpectations(timeout: 1, handler: nil)

    XCTAssertEqual(result.base, "USD")
    XCTAssertFalse(result.rates.isEmpty)
  }

  func testLatest() throws {
    let expectation = self.expectation(description: #function)
    let bling = try makeBling(withFixture: "latest")
    var result: ConversionRates!

    bling.latest()
      .sink(receiveCompletion: { _ in expectation.fulfill()},
            receiveValue: { result = $0 })
      .store(in: &subscriptions)

    waitForExpectations(timeout: 1, handler: nil)

    XCTAssertEqual(result.base, "USD")
    XCTAssertFalse(result.rates.isEmpty)
  }

  func testOHLC() throws {
    let expectation = self.expectation(description: #function)
    let bling = try makeBling(withFixture: "ohlc")
    var result: OHLC!

    let date = Date(timeIntervalSince1970: 1500289200)

    bling.ohlc(startTime: date, period: "30m", symbols: "GBP", "EUR", "HKD")
      .sink(receiveCompletion: { _ in expectation.fulfill()},
            receiveValue: { result = $0 })
      .store(in: &subscriptions)

    waitForExpectations(timeout: 1, handler: nil)

    XCTAssertEqual(result.base, "USD")
    XCTAssertFalse(result.rates.isEmpty)
    XCTAssertNotNil(result.rates["EUR"])
  }

  func testUsage() throws {
    let expectation = self.expectation(description: #function)
    let bling = try makeBling(withFixture: "usage")
    var result: Usage!

    bling.usage()
      .sink(receiveCompletion: { _ in expectation.fulfill()},
            receiveValue: { result = $0 })
      .store(in: &subscriptions)

    waitForExpectations(timeout: 1, handler: nil)

    XCTAssertEqual(result.status, .active)
    XCTAssertFalse(result.plan.features.base)
    XCTAssertEqual(result.requests, 7)
    XCTAssertEqual(result.quota, 1_000)
  }

  private func makeBling(withFixture name: String) throws -> Bling {
    let fixture = try loadFixture(named: name)
    MockURLProtocol.requestHandler = { _ in
      (HTTPURLResponse(), fixture)
    }
    let configuration = MockURLProtocol.mockedURLSessionConfiguration()
    return Bling(appId: "", sessionConfiguration: configuration)
  }

  private func loadFixture(named name: String) throws -> Data {
    let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json")!
    return try Data(contentsOf: url)
  }

}
