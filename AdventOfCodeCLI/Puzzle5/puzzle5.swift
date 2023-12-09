//
//  puzzle5.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 05.12.23.
//

import Foundation

func puzzle5() {
    var lines = contentPuzzle5.split(separator: "\n").map({ String($0) })
    let seedLine = lines.removeFirst()
    let seeds = seedLine.suffix(from: String.Index(utf16Offset: 7, in: lines[0])).split(separator: " ").compactMap({ Int(String($0)) })

    // Setup
    var maps: [Map] = []

    var startIndex = 0
    for (index, row) in lines.enumerated() {
        if row.contains("map") {
            // new group ended right here
            if(startIndex > 0) {
                maps.append(Map(mapString: Array(lines[startIndex...index - 1])))
            }
            startIndex = index + 1
        }
    }
    // add the last one
    maps.append(Map(mapString: Array(lines[startIndex...lines.count - 1])))


    let newSeeds = seeds.map {
        return maps.reduce($0) { seed, map in
            return map.newLocation(for: seed)
        }
    }
    print("Result puzzle 1")
    print(newSeeds.reduce(Int.max) { $0 > $1 ? $1 : $0 })

    var otherSeeds: [SeedRange] = []
    for i in stride(from: 0, to: seeds.count, by: 2) {
        otherSeeds.append(SeedRange(start: seeds[i], length: seeds[i+1]))
    }
    var otherSeedMin = otherSeeds.map({ _ in Int.max})
    for (i, seedRange) in otherSeeds.enumerated() {
        for pos in (seedRange.start...seedRange.end) {
            let newPos = maps.reduce(pos) { seed, map in
                return map.newLocation(for: seed)
            }
            otherSeedMin[i] = min(newPos, otherSeedMin[i])
        }
    }
    print("Result puzzle 2")
    print(otherSeedMin)
    print(otherSeedMin.reduce(Int.max) { $0 > $1 ? $1 : $0 })
}

struct SeedRange {
    let start: Int
    let length: Int

    var end: Int { start + length - 1}
}

struct Map {
    struct Range {
        let destinationStart: Int
        let sourceStart: Int
        let length: Int

        func contains(seed: Int) -> Bool {
            return seed >= sourceStart && seed < (sourceStart + length )
        }

        func newPosition(for seed: Int) -> Int {
            guard self.contains(seed: seed) else {
                return seed
            }
            let newSeed = destinationStart + (seed - sourceStart)
            return newSeed
        }
    }

    let ranges: [Range]

    init(mapString: [String]) {
        self.ranges = mapString.map({ line in
            let values = line.split(separator: " ").compactMap({ Int($0) })
            return Range(destinationStart: values[0], sourceStart: values[1], length: values[2])
        })
    }

    func newLocation(for seed: Int) -> Int {
        for range in ranges {
            if range.contains(seed: seed) {
                return range.newPosition(for: seed)
            }
        }
        return seed
    }
}
