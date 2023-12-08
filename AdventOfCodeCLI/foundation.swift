//
//  foundation.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 05.12.23.
//

import Foundation

public func measureExecutionTime(closure: () -> Void) -> TimeInterval {
    let startTime = DispatchTime.now()
    closure()
    let endTime = DispatchTime.now()

    let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let executionTime = TimeInterval(nanoTime) / 1_000_000_000

    return executionTime
}

public func contentOfResource(name: String, type: String) -> String {
    let filePath = Bundle.main.path(forResource:name, ofType: type)!
    let contentData = FileManager.default.contents(atPath: filePath)!
    let content = String(data:contentData, encoding:String.Encoding.utf8)
    return content!
}

public extension RandomAccessCollection {
    subscript(at index: Index) -> Element? {
        self.indices.contains(index) ? self[index] : nil
    }
}

extension String {
    func mid(start: Int, length: Int) -> String {
        let startPos = self.index(self.startIndex, offsetBy: start)
        let endPos = self.index(self.startIndex, offsetBy: start + length)
        return String(self[startPos..<endPos])
    }
}

extension Array {
    func splat() -> (Element,Element) {
        return (self[0],self[1])
    }

    func splat() -> (Element,Element,Element) {
        return (self[0],self[1],self[2])
    }

    func splat() -> (Element,Element,Element,Element) {
        return (self[0],self[1],self[2],self[3])
    }

    func splat() -> (Element,Element,Element,Element,Element) {
        return (self[0],self[1],self[2],self[3],self[4])
    }
}
