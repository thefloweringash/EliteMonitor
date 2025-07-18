//
//  NDJSONBuffer.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Foundation

public class NDJSONBuffer {
  var buffer = Data(count: 4096)
  var end: Data.Index

  init() {
    end = buffer.startIndex
  }

  public func clear() {
    end = buffer.startIndex
  }

  public func fill(
    read: (UnsafeMutableRawBufferPointer) throws -> Int,
    onChunk: (Data) -> Void
  ) rethrows {
    while true {
      // We know we have no complete records, so fill our buffer

      // But out buffer might be full, and we have to progress
      if end == buffer.endIndex {
        // TODO: this seems silly
        buffer += Data(count: buffer.count)
      }

      guard buffer[end...].withUnsafeMutableBytes({ buf in
        let result = try! read(buf)
        end = end.advanced(by: result)
        return result != 0
      }) else {
        return
      }

      // After each read(), clear out as many whole chunks as possible
      var start = buffer.startIndex
      while
        start < end,
        let newline = buffer[start..<end].firstIndex(of: 0x0A)
      {
        onChunk(buffer[start...newline])
        start = newline.advanced(by: 1)
      }

      // Compact the remaining chunk into the buffer
      if start != buffer.startIndex {
        if start == end {
          end = buffer.startIndex
        } else {
          let remaining = end - start
          buffer.withUnsafeMutableBytes { buf in
            let base = buf.baseAddress!
            memmove(base, base + start, remaining)
          }
          end = remaining
        }
      }
    }
  }
}
