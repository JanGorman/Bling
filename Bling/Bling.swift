//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import Foundation

open class Bling {

  private let appId: String
  private let session: URLSession

  public init(appId: String, sessionConfiguration: URLSessionConfiguration = .default) {
    self.appId = appId
    self.session = URLSession(configuration: sessionConfiguration)
  }

  /// Convert from one currency to another https://docs.openexchangerates.org/docs/convert
  public func convert(value: Double, from: String, to: String, completion: @escaping (Result<Conversion>) -> Void) {
    newTask(url: BlingUrl.conversion(appId: appId, value: value, from: from, to: to), completion: completion).resume()
  }

  private func newTask<T: Decodable>(url: BlingUrl, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask {
    return session.dataTask(with: url.toUrl()) { data, _, error in
      var response: T? = nil
      defer {
        completion(Result(value: response, error: error))
      }
      guard let data = data else { return }
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      response = try? decoder.decode(T.self, from: data)
    }
  }

  /// Retrieve dictionary of available currencies https://docs.openexchangerates.org/docs/currencies-json
  public func currencies(completion: @escaping (Result<[String: String]>) -> Void) {
    newTask(url: BlingUrl.currencies(appId: appId), completion: completion).resume()
  }

  /// Retrive historical conversion rates https://docs.openexchangerates.org/docs/historical-json
  public func historical(base: String = "USD", date: Date, completion: @escaping (Result<ConversionRates>) -> Void) {
    newTask(url: BlingUrl.historical(appId: appId, base: base, date: date), completion: completion).resume()
  }

  /// Retrieve latest conversion rates https://docs.openexchangerates.org/docs/latest-json
  public func latest(base: String = "USD", completion: @escaping (Result<ConversionRates>) -> Void) {
    newTask(url: BlingUrl.latest(appId: appId, base: base), completion: completion).resume()
  }

  /// Retrieve OHLC https://docs.openexchangerates.org/docs/ohlc-json
  public func ohlc(base: String = "USD", startTime: Date, period: String, symbols: String...,
                   completion: @escaping (Result<OHLC>) -> Void) {
    newTask(url: BlingUrl.ohlc(appId: appId, base: base, startTime: startTime, period: period, symbols: symbols),
            completion: completion).resume()
  }

  /// Retrieve your API usage https://docs.openexchangerates.org/docs/usage-json
  public func usage(completion: @escaping (Result<Usage>) -> Void) {
    newTask(url: BlingUrl.usage(appId: appId), completion: completion).resume()
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
      return URLQueryItem(name: key, value: value)
    }
    return components!.url!
  }

}
