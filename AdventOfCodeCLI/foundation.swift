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
    func remove(prefix: String) -> String? {
        if self.hasPrefix(prefix) {
            return String(self.dropFirst(prefix.count))
        } else {
            return nil
        }
    }

    func mid(start: Int, length: Int) -> String {
        let startPos = self.index(self.startIndex, offsetBy: start)
        let endPos = self.index(self.startIndex, offsetBy: start + length)
        return String(self[startPos..<endPos])
    }

    public subscript(_ idx: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: idx)]
    }

    public func suffix(_ idx: Int) -> String {
        let index = self.index(from: idx)
        return Self(self.suffix(from: index))
    }

    public func mid(_ range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func numberOfMatches(pattern: String) -> Int {
        let pattern = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = pattern.numberOfMatches(in: self, range: NSRange(self.startIndex..., in: self))
        return matches
    }

    func numberOfMatchesAndReversed(pattern: String) -> Int {
        let pattern = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = pattern.numberOfMatches(in: self, range: NSRange(self.startIndex..., in: self))

        let reversed = String(self.reversed())
        let matchesReversed = pattern.numberOfMatches(in: reversed, range: NSRange(reversed.startIndex..., in: reversed))
        return matches + matchesReversed
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

    mutating func swapElements(at index1: Int, and index2: Int) {
        guard index1 >= 0, index2 >= 0, index1 < self.count, index2 < self.count else {
            print("Invalid indices")
            return
        }
        (self[index1], self[index2]) = (self[index2], self[index1])
    }
}
