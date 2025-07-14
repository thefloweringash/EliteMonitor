//
//  Material.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import Foundation

protocol Material: Decodable {
  var localizedName: LocalizedStringResource { get }
  var grade: Int? { get }
  var asAnyMaterial: AnyMaterial { get }
//  var category: Int { get }
}

extension Material {
  var cap: Int? {
    guard let grade else { return nil }
    return 350 - (50 * grade)
  }
}

enum AnyMaterial: Hashable, Codable, Material, RawRepresentable {
  enum DecodeErrors: Error {
    case unknownMaterial(String)
  }

  case encoded(EncodedMaterial)
  case manufactured(ManufacturedMaterial)
  case raw(RawMaterial)

  var localizedName: LocalizedStringResource {
    switch self {
    case let .encoded(x): x.localizedName
    case let .raw(x): x.localizedName
    case let .manufactured(x): x.localizedName
    }
  }

  var grade: Int? {
    switch self {
    case let .encoded(x): x.grade
    case let .raw(x): x.grade
    case let .manufactured(x): x.grade
    }
  }

  init?(rawValue: String) {
    if let encoded = EncodedMaterial(rawValue: rawValue) {
      self = .encoded(encoded)
    } else if let manufactured = ManufacturedMaterial(rawValue: rawValue) {
      self = .manufactured(manufactured)
    } else if let raw = RawMaterial(rawValue: rawValue) {
      self = .raw(raw)
    } else {
      return nil
    }
  }

  init(from decoder: Decoder) throws {
    let svc = try decoder.singleValueContainer()
    let stringName = try svc.decode(String.self).lowercased()

    guard let value = Self(rawValue: stringName) else {
      throw DecodeErrors.unknownMaterial(stringName)
    }
    self = value
  }

  var asAnyMaterial: AnyMaterial { self }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }

  var rawValue: String {
    switch self {
    case let .raw(x): x.rawValue
    case let .manufactured(x): x.rawValue
    case let .encoded(x): x.rawValue
    }
  }
}
