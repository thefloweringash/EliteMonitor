//
//  NewlineDelimitedSequence.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Foundation

public struct NewlineDelimitedSequence: ~Copyable {
  var buffer = Data(count: 4096)
  var end: Data.Index
  var ptr: Data.Index

  public init() {
    ptr = buffer.startIndex
    end = buffer.startIndex
  }

  public mutating func clear() {
    ptr = buffer.startIndex
    end = buffer.startIndex
  }

  public mutating func next(
    read: (UnsafeMutableRawBufferPointer) throws -> Int,
  ) throws -> Data? {
    // try to pull a chunk
    while true {
      if let newline = buffer[ptr..<end].firstIndex(of: 0x0A) {
        let chunk = buffer[ptr...newline]
        ptr = newline.advanced(by: 1)

        // after discharging a chunk, see if we can trivially clean up the buffer
        if ptr == end {
          ptr = buffer.startIndex
          end = buffer.startIndex
        }

        return chunk
      } else if ptr == buffer.startIndex && end == buffer.endIndex {
        // buffer is full, need to expand
        // TODO: this seems silly
        buffer += Data(count: buffer.count)
      } else if end == buffer.endIndex {
        // buffer has partial contents, cannot be filled, but is not full (space at the beginning)
        // compact by moving
        if ptr == end {
          // TODO: can we
          ptr = buffer.startIndex
          end = buffer.startIndex
        } else {
          let remaining = end - ptr
          buffer.withUnsafeMutableBytes { buf in
            let base = buf.baseAddress!
            memmove(base, base + ptr, remaining)
          }
          ptr = buffer.startIndex
          end = buffer.startIndex + remaining
        }
      } else {
        guard try buffer[end...].withUnsafeMutableBytes({ buf in
          let result = try read(buf)
          end = end.advanced(by: result)
          return result != 0
        }) else {
          return nil
        }
      }
    }
  }
}
