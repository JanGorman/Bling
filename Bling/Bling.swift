//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import Foundation
import Combine

open class Bling {

  private let appId: String
  private let session: URLSession

  public init(appId: String, sessionConfiguration: URLSessionConfiguration = .default) {
    self.appId = appId
    self.session = URLSession(configuration: sessionConfiguration)
  }

  /// Convert from one currency to another https://docs.openexchangerates.org/docs/convert
  public func convert(value: Double, from: String, to: String) -> AnyPublisher<Conversion, Error> {
    newTask(url: BlingUrl.conversion(appId: appId, value: value, from: from, to: to))
  }

  /// Retrieve dictionary of available currencies https://docs.openexchangerates.org/docs/currencies-json
  public func currencies() -> AnyPublisher<[String: String], Error> {
    newTask(url: BlingUrl.currencies(appId: appId))
  }

  /// Retrieve historical conversion rates https://docs.openexchangerates.org/docs/historical-json
  public func historical(base: String = "USD", date: Date) -> AnyPublisher<ConversionRates, Error> {
    newTask(url: BlingUrl.historical(appId: appId, base: base, date: date))
  }

  /// Retrieve latest conversion rates https://docs.openexchangerates.org/docs/latest-json
  public func latest(base: String = "USD") -> AnyPublisher<ConversionRates, Error> {
    newTask(url: BlingUrl.latest(appId: appId, base: base))
  }

  /// Retrieve OHLC https://docs.openexchangerates.org/docs/ohlc-json
  public func ohlc(base: String = "USD", startTime: Date, period: String, symbols: String...) -> AnyPublisher<OHLC, Error> {
    newTask(url: BlingUrl.ohlc(appId: appId, base: base, startTime: startTime, period: period, symbols: symbols))
  }

  /// Retrieve your API usage https://docs.openexchangerates.org/docs/usage-json
  public func usage() -> AnyPublisher<Usage, Error> {
    newTask(url: BlingUrl.usage(appId: appId))
  }

  private func newTask<T: Decodable>(url: BlingUrl) -> AnyPublisher<T, Error> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    return session.dataTaskPublisher(for: url.toUrl())
      .map(\.data)
      .decode(type: T.self, decoder: decoder)
      .eraseToAnyPublisher()
  }

}

private enum BlingUrl {

  private static let baseUrl = "https://openexchangerates.org/api/"

  case conversion(appId: String, value: Double, from: String, to: String)
  case currencies(appId: String)
  case historical(appId: String, base: String, date: Date)
  case latest(appId: String, base: String)
  case ohlc(appId: String, base: String, startTime: Date, period: String, symbols: [String])
  case usage(appId: String)

  func toUrl() -> URL {
    switch self {
    case .conversion(let appId, let value, let from, let to):
      return url(path: "convert/\(value)/\(from)/\(to)", queryItems: ["appId": appId])
    case .currencies(let appId):
      return url(path: "currencies.json", queryItems: ["app_id": appId])
    case .historical(let appId, let base, let date):
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      return url(path: "historical/\(formatter.string(from: date)).json", queryItems: ["app_id": appId, "base": base])
    case .latest(let appId, let base):
      return url(path: "latest.json", queryItems: ["app_id": appId, "base": base])
    case .ohlc(let appId, let base, let startTime, let period, let symbols):
      let formatter = ISO8601DateFormatter()
      return url(path: "ohlc.json", queryItems: ["app_id": appId, "base": base, period: "period",
                                                 "start_time": formatter.string(from: startTime),
                                                 "symbols": symbols.joined(separator: ",")])
    case .usage(let appId):
      return url(path: "usage.json", queryItems: ["app_id": appId])
    }
  }

  private func url(path: String, queryItems: [String: String]) -> URL {
    var components = URLComponents(string: BlingUrl.baseUrl)
    components?.path += path
    components?.queryItems = queryItems.map { key, value in
      URLQueryItem(name: key, value: value)
    }
    return components!.url!
  }

}
