//
//  Material.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import Foundation

protocol Material: Decodable {
  var grade: Int? { get }
//  var category: Int { get }
}

extension Material {
  var cap: Int? {
    guard let grade else { return nil }
    return 350 - (50 * grade)
  }
}

enum AnyMaterial: Decodable, Material {
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

  init(from decoder: Decoder) throws {
    let svc = try decoder.singleValueContainer()
    let stringName = try svc.decode(String.self).lowercased()

    if let encoded = EncodedMaterial(rawValue: stringName) {
      self = .encoded(encoded)
    } else if let manufactured = ManufacturedMaterial(rawValue: stringName) {
      self = .manufactured(manufactured)
    } else if let raw = RawMaterial(rawValue: stringName) {
      self = .raw(raw)
    } else {
      throw DecodeErrors.unknownMaterial(stringName)
    }
  }
}
