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
