//
//  Config.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 13/12/2025.
//

import UIKit

final class Config: NSObject {

  static var environment: Environment = {
#if DEV
    return .dev
#elseif PROD
    return .prod
#else
    return .appStore
#endif
  }()

  static var pushEnvironment: Environment = {
#if DEV
    return .dev
#elseif PROD
    return .prod
#else
    return .appStore
#endif
  }()

  static var appName: String { "cast-hub" }

  static var appDisplayName: String {
    getValue(for: "CH_APP_NAME", fallback: "Cast Hub")
  }


  static var baseAPIHost: String {
    getValue(for: "CH_BASE_API_HOST", fallback: "itunes.apple.com")
  }

  static var basePath: String { "/" }
  static var batchSize: Int { 10 }

  enum Environment {
    case dev
    case prod
    case appStore

    var name: String {
      switch self {
      case .dev:      return "DEV"
      case .prod:     return "PRODUCTION"
      case .appStore: return "APPSTORE"

      }
    }

    var icon: String {
      switch self {
      case .dev:      return "🛠️"
      case .prod:     return "🚀"
      case .appStore: return "🚀"
      }
    }
  }

  // MARK: - Private Methods

  private static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
    guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
      throw ConfigError.missingKey
    }

    switch object {
    case let value as T:
      return value

    case let string as String:
      guard let value = T(string) else { fallthrough }
      return value

    default:
      throw ConfigError.invalidValue
    }
  }

  private static func getValue<T>(for key: String, fallback: T) -> T where T: LosslessStringConvertible {
    do {
      return try value(for: key)
    } catch {
      print("Error fetching value for key \(key): \(error). Using fallback value \(fallback).")
      return fallback
    }
  }

  private enum ConfigError: Swift.Error {
    case missingKey
    case invalidValue
  }
}

