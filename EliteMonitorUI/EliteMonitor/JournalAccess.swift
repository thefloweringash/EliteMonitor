//
//  JournalAccess.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/07/26.
//

import Foundation
import OSLog

enum JournalAccess {
  static let logger = Logger(subsystem: "nz.org.cons.EliteMonitor", category: "JournalAccess")
  static let directoryKey = "JournalContainerDirectory"

  static func getContainerDirectory() -> URL? {
    guard let bookmark = UserDefaults.standard.data(forKey: directoryKey) else { return nil }

    let directory: URL
    var dataIsStale = false
    do {
      directory = try URL(
        resolvingBookmarkData: bookmark,
        options: .withSecurityScope,
        bookmarkDataIsStale: &dataIsStale
      )
    } catch {
      logger.error("Failed to restore container directory bookmark: \(error)")
      return nil
    }

    do {
      if dataIsStale {
        let newBookmark = try createBookmark(directory)
        UserDefaults.standard.setValue(newBookmark, forKey: directoryKey)
      }
    } catch {
      logger.error("Failed to update stale container directory bookmark: \(error)")
    }

    return directory
  }

  static func saveContainerDirectory(_ directory: URL) {
    do {
      let bookmark = try createBookmark(directory)
      UserDefaults.standard.setValue(bookmark, forKey: directoryKey)
    } catch {
      logger.error("Failed to persist container directory: \(error)")
    }
  }

  private static func createBookmark(_ directory: URL) throws -> Data {
    let release = directory.startAccessingSecurityScopedResource()
    defer {
      if release { directory.stopAccessingSecurityScopedResource() }
    }

    return try directory.bookmarkData(
      options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
      includingResourceValuesForKeys: [.isDirectoryKey],
    )
  }
}
