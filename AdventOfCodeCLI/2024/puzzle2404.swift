//
//  puzzle2404.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 03.12.24.
//

import Foundation

func puzzle2404() {

    func countXmas(in string: String) -> Int {
        
        func countVertical(in grid: [[String]]) -> Int {
            guard !grid.isEmpty else { return 0 }
            let rows = grid.count
            let cols = grid[0].count

            var count = 0
            for col in 0..<cols {
                var verticalString = ""
                for row in 0..<rows {
                    verticalString += grid[row][col]
                }

                count += verticalString.numberOfMatchesAndReversed(pattern: #"(XMAS)"#)
            }

            return count
        }

        func countDiagonalTextSmart(in grid: [[String]]) -> Int {
            let rows = grid.count
            guard rows > 0 else { return 0 }
            let cols = grid[0].count

            var diagonalsTLBR = [Int: String]() // Top-left to bottom-right
            var diagonalsTRBL = [Int: String]() // Top-right to bottom-left

            // Group characters into diagonals
            for r in 0..<rows {
                for c in 0..<cols {
                    let diff = r - c // Key for top-left to bottom-right
                    let sum = r + c  // Key for top-right to bottom-left

                    diagonalsTLBR[diff, default: ""] += grid[r][c]
                    diagonalsTRBL[sum, default: ""] += grid[r][c]
                }
            }

            var count = 0

            // Check each diagonal for the search text
            for diagonal in diagonalsTLBR.values {
                count += diagonal.numberOfMatchesAndReversed(pattern: #"(XMAS)"#)
            }
            for diagonal in diagonalsTRBL.values {
                count += diagonal.numberOfMatchesAndReversed(pattern: #"(XMAS)"#)
            }

            return count
        }

        let normalCount = string.numberOfMatchesAndReversed(pattern: #"(XMAS)"#)

        let input = string.split(separator: "\n").map { String($0) }
        let grid = input.map { Array($0).map { String($0) } }

        let diagonalCount = countDiagonalTextSmart(in: grid)
        let verticalCount = countVertical(in: grid)

        print("n: \(normalCount), d: \(diagonalCount), v: \(verticalCount)")
        return normalCount + diagonalCount + verticalCount
    }

    func countXmasCross(in string: String) -> Int {
        func count(patternString: String, in grid: [[String]]) -> Int {
            let rows = grid.count
            let cols = grid[0].count

            let pattern = patternString.split(separator: "\n").map { String($0) }.map { Array($0).map { String($0) } }
            let patternRows = pattern.count
            let patternCols = pattern[0].count

            // Function to check if the pattern matches starting from a specific top-left position
            func matchesPattern(at startRow: Int, startCol: Int) -> Bool {
                for r in 0..<patternRows {
                    for c in 0..<patternCols {
                        let gridChar = grid[startRow + r][startCol + c]
                        let patternChar = pattern[r][c]
                        if patternChar != "." && gridChar != patternChar {
                            return false
                        }
                    }
                }
                return true
            }

            var count = 0

            for c in 0..<(rows - patternRows + 1) {
                for r in 0..<(cols - patternCols + 1) {
                    if matchesPattern(at: r, startCol: c) {
                        count += 1
                    }
                }
            }

            return count
        }

        let data = string.split(separator: "\n").map { String($0) }.map { Array($0).map { String($0) } }

        let d1 = count(patternString: "M.S\n.A.\nM.S", in: data)
        let d2 = count(patternString: "S.S\n.A.\nM.M", in: data)
        let d3 = count(patternString: "S.M\n.A.\nS.M", in: data)
        let d4 = count(patternString: "M.M\n.A.\nS.S", in: data)

        return d1 + d2 + d3 + d4
    }


    print(countXmas(in: puzzle2404data))
    print(countXmasCross(in: puzzle2404data))
}

private let puzzle2404demoData = """
.M.S.....
..A..MSMS
.M.S.MAA.
..A.ASMSM
.M.S.M...
.........
S.S.S.S.S
.A.A.A.A.
M.M.M.M.M
"""


private let puzzle2404data = """
XMXXXMMXXSXMSMMMSXMSSSMASXMAXSMMMAASAMXASASXSXSASMSMSSSXSMASXMMSAMMMSAMXSMMMAMMSMMSXSAMXMSMSASMSMSMSSSMMSMMMMMASMSSMSSXMAMXMASAMAMXSXSXMMASA
MXMMMMMSXMASMMAASAMXMASAMXMXXSAASMMSAMXXAAXAAAAAXAAXAXMASXASAXAAASAXAASMXMAMXMAXMAMAMAMXXSAMXAXAAAAXAAAMAMAMMSAMSAXAMMSMAMSMMAMXSXMSAMXXSASX
XAAMAAAMXXMMASMMMXMASMMXSAXSAMSMSAASAMMSMSMMMMMAMSMSXXMXMMMSAMSSMMASXMMMXSSSSMSSMASASAMMMMAMMMSMSMSMSMMMSSXMAMAMXMMXMAAXXXAASAMAMASMXMAXMASA
SSMXSMSMXSSSMMMXMXAMXAAASASMXMASXMMSXMAAXAAAXMXAXAXSMMMAMAMMMMXAXXXMAXMXAXXAAAMAMAXXSASXASAMAAXXXAXAXSMMAAAMSSSMMXAMMSSSMMSMMAMASXMAAMMXMXMX
AAAXMAXMAXAAAXAAMXSSSMMMSXXMASMSMMASAMSSMMSXSXSASMAMAAXMSAXAAMXMMMMSXMSMSSMSMMMAMMSMSMMMXMAMSASAMAMXSASMMMMAAAAMSMSAMAMAAXMASMMXSASMXAXMXMAM
SXMXSASMMMSMMMMMSAXAAXSXMAMMAXMSXMAXAMAXAXMAMXMASMAMSSSMSXSSXSAAAAAXAXXAXAMXMXMAMXAAXAAXMSSMMMAXSXSXSAMSXXSMMSMMAAXSMAMSMMSAMAXASAMASMMXAAAM
MASMAXSAMAAAMXAXMXMXXMASAAMMSXMMAMMSSMAXSASXXMXAXXXMXAAAXAXXASXSSSSSMMMSSXMAMAXAMXMSMMMSAAMAMSMMMASAMMMXMXMAXMMSMSMMSXMAXAMMMSMASAMMMASMSSSS
SAMAMXSXMSSSMMSMMMSAXMAXMXSAXASMSMAAXMXXMAAAASMSSMXAMXMMSMMMXMAXAAAMMAXXSAXSSSMSSXAAAAAMMXSAMSXAMAMAMXMAXSMMMAAMXAAMAMXAMMSXAXMMMASXSXMAMAMM
MXMXXXMAAAXXXXMASAXSAXAXSAMMSAMAMMMSSMSMMSMSMMAMAMAXAMAMXAAXAMXMMMSMSXSASXMMAMAAAMAMXMXSAAXMSXMMMSSMMSSMASAMMMMMSSXMAMXXSSMMXSAMXMAXXAMSMSMM
SASXSASAMASMMXSXMAMMMMMMMAMXMAMMMAAMXAXSAAAAMMXMAAMSSXMXSSMSXSXMAXAAAAMXMAXMAMMMMSSSMSXMMSSMSASXXXMASXAMAXAMMMMMXAMXASXMMAASMSXSMMSASMMXAMAM
SASASMSASAXAMMMMSMMAAAMASMMXSXMXSMSXMXMMSMSMSMSSSSMAXASAMAMAMSXSASMMMXMXSXMMXMXMXAAAXAMXAMAASAMASXSXMSXMAMSMSASXSAXMAXMASMMMAMXMAAXMASAMAMAA
MAMXMXSAMXSSMSAAAASXMMSASASXAXAXAMMXSMXMMMMAXAAXAAMASMMASMSAASXXXXAASAMXMXAXAXMXMMMMMMMMSMMMMXMSAMXAMAMMMMMASASMAAMMSMSMMMXMXMASMMXXMAMMASMS
MXMXSAMAMMXMASAMSMMAMMMMXAAASXXSAMMASAAXMAMMMMMXXAMXSMMXMAXAMSAMSMSMSASASMSMSXSASXSMMAMXAAMAXSMXMXSMSAMXXASAMAMXMXMAMAMAAMASMSMSASASAMXSXSAM
SMMAMASXMXMMXMAMXXSAMSASMSMXAAAMXMMASMMSSMSXAXSXSXSAMXMSMXMSMMAMXAAASAMXMSAAAASASXAMSAMMSSMASMMAMXAXMAMXMAXAMXMSXXMASMSXMSMSAXXSAMMMXSMMAMMM
XAMXSAMAMXSAMXXSXAMXMSAXXXXXMMMMSMMASASAAXSMMXSAAMMXSMMAAAAMASXMMSMMMSMXXAMMMAMAMMAMSAMXAXMXMMAXSAMXMAMSXMXAMAMXMXMASXAMMSAMMMAMAMXAASAMXMXS
SSMMMMSAMAMAMSMSMMMSMMSMAXMXXXMASAMSSXMMSMMAMAMMMMMXMMSSMXMSAMAMAMSXMASXXMASXSMXMAMMMXMMASXSAMXMXMMXMSMSASMMSXSAMAMAMMSAMXAMMAMMMMMMXSAMXSSX
AAMXAAXASXSAMAAXAAAAXAASAMXAMXMASXMASAXMAMXAMASASASAAMAMXSAMAMXMASXXSAXMXXMXMASMAMXAMASMAMASMMMMXMSXXXAMAMSAAASXSASAXAAAXSAMXXSAMAMXASMMAMAS
SSMSMMSAMASMXMXMMMXMSXMAMAXMSAMXMXAMXSXSMMXSSMXAMASXXMMSXSAMXXAXMMXAMXSAMAMASMXMAXSASMSMSMAMAAAXXXAMAMMMMMMXMMMXSASAMSSXMAMXMAXASMSAMXXMASMA
XMASAAMAMMXAXSMSXSSXSAMXASXAMASAMAXXAMXMAXAXAMSXMMMMSMMMAMXXASXSSMMXSXMMSXXAXXMMAMSAMAXAXMASMMSXXAAXAXMAXXXSXXMASXMAXXMMASXMSMSAMAXXMAMMMXXM
MMAMMMSXMXMMSMAXAAXAXMMSAMXMSMMMSSMMMSXSAMXSAMAASXSXAMAMMMMMMSAAAASAMAXAXXMSSSSMSXMAMMMXMXAMXSAASXMMSXMASMASXASAMMSXSASMAMAAAMMMMMMXXXSASMMX
ASAMSAMXMAAXAMXMMMMSMMMAMSMXAMAXXMAXXAMAMMAMAMSSMAXSMSAMAAAAAMMMSMMAXXMMSMMAAAXAMMSSMXSSMSMSMMMMMAAAXAXAAMAMSXMASMMASAMMXSMMMSAXMAMXAASMXAXX
XXASXMXAXMSSMXAXAMSMAAAAXAXSMMSSSSSMMASMMMASMMMMMXMMMAASXSSMXXXXMMSSMAXAAAMMSMMMMXMASAMXAAAAMAMASMMMSMMSAMAMSMMAMAMMMAMXMXAAXMXMMAXSMMSXSMMS
XSXMAMSSXSAMXSMXAXAMMMXSSMMAXSXAMAXAXASXMMXSMAMMMXMAAMXMXAXXMSMMXAAAXMMSXMMMAMAXXXSAMXSMSMSMXMSXSSMAAXAMASXSXAMMSAMXMAMXMSAMXSASMSMXAXMMAXAX
MAMXSXAMXMAXMAMXSSMSSSMAAXAMXAMSMMSSMXSAMMSXMAMAAAMAXSAMMXMASAAXMMSSMXXMASMSASXXSAMXSAMMMMXXXMAXXXMXSSXSAMXSMSMAAAMMXXMAXAXSXMASAMMSMMSSMMAS
AMXAXMMMMXAMMSAAXAMAAAASMMMXMXAMAMAMMMSAMSASMXSMXMSAXSAMXAXMSSSMXMAXMAMXXAAMMMMAAXMAMAXMXXAMMMSAMASXAAXMXMAMAAMXXMMSASMXMMXSAMAMAMXASAAAXXXX
MMMMMXAASXSAAMMMSMMXSMMMXSXASXMXAMXSXAMAMMASXMAXAAMMMSXXSXSXXXMXAMXXMSSXMMAMAXMXMSMSSSMSSMMSAAMXSAMMMMMMAMASXMSMMSXMASAMXXXXAMAXSMSAMMXMMSXM
XMAXASMSMAMMMMAXAXMMMMXMXXSAXMMSASMMMMMMMMAMAMAMMSMMAXMXSAMXMXSSMSSMAAMASXMSSSMMXXXMAXAAMSAMMSMAMASMMMASXSASAMMAASAMXMMAXMMSXMAXMXMAMAMMAMAS
XXSMAMXAMXMAXSMXMMSASAMXAXMMSMXAAMAMAAASMSXSAMXSAAAXXXXAMXMASAAAMAAMMMSAMAXAAAMAAMXMAMMMSMXXXAMXSAMXASAXMAMSAXMMMXMSSSXSXAAAAMSSMASMMAMMASAM
XAMAMXXSSXSAMAAMSASXSASMMXSAAXAMMMMXSSMSAAAMASXMXSMMSMMMSXXASMSMMSSMXAMASXMMSMMSMSASMSMSAMXXSXSMMMMSAMASXMASAMXSMSMAMMAMXMMSSMAAMAMXMAMXAMAS
XMXAXSXMAASXXMSMMAMAXMMAAAMMMSXXXXSAMXXMMMSMASXSXMAAXAAXMMMXSXMXAAAMMMSMMAXAAAAAAXASAAXSASXMSAMXAAMMXXXMASAMXAXSAAMMXSAMAMMXAMSAMXXXMASMASAM
MAAXXSSMMMMASXMMMSMSMMSAMXSSMMMSAASAMXSMXAXAMXASAMMMMSMMAAXXMASMSMMAAMAASXMMSSMMSMSMXMMSAMXMMAMSMSXAMSXSXMXSXSAMSMSXASASXSSSMMXXSSMSMAMMAMAS
AXXXXXAMXAMAMAAXXAAMAAAAXAAAASASMXMAMAMMMSSMXMMMAMMAXXXXASXAMMMMMXXMXXMMMAAMAMXXMXXAMXMMASXXMAMXMAMAMMAMXMXXMXMMMXMMMMXMAAAAXXXAAAAXMASMXSMM
SMMSXSAMSMMMMSMMMMMMMMMMMMSMMMASXMSAMXSAAAAXAXASXMAXMASAMXXXAAAAAAXSMMSSSSMMASAXMAMMMMXSXMASXSSXMSSSMSAMAMMMSAMASAXASXMMMMSMMSMMMMMMMSAMXSAM
MAXAAXAMAXMXAXASXSSXXAAMXMXXSMMMAXSXMMSMMSMMMXMSMMMSMAMMSMMMMSMSMSAAXXAAXAASAMAAMMSMAAMAMMMXMAAXXAAAASASXSAAMAXASMSMMAAXXXAMAXXAAAAMXMASASAM
MSMMSSMSSSMMMMAXAAASMSMSAASASXSMXMMAXAXXAXXMSAMXAAXAMMSASAASAMAXAXMMMMMSSSMMAXSXSMAXSSSXSAMXSMSMMMSMMMAMMSMSMSMAXMAMXSMMSXMAXMXSSSMSMSXMXXXM
AAXXAAMAASXAXSAMMMMXXAASXMMAMAXAAMSSMSSMMMAASMXSSMXXMXMAMSASASAMAMSXAASAMXMSMMXAMXMMMAMASMSASXMASAMXAMXMXXMXAXMMMSSSMAASXMXSAMXAAXAAASXMXMXX
SXSMSSMSXMSMMAMASAMXMMMMAMMAMMMASAAAAAXAASXMMSAAAMXSXMMSMMXSXMAMXMAXSXMXMAXAMMMAMAMAMAMMMAMAXASMMMMAXXMAMXSMXMAMAXAAMSMMMXAMAMAMAMSMMMASAMSA
XAXAXXAXMXXSXAMMSASXSXASXMSMSXXAMMMMMMMMASAAAMMSMMAMASAMXAAXMXASAMXAXASXSMSASAMAMASASMSSMMMSMMMSSXMSMSMSXMAMSSXMMXMAMXAAAMMSMSAXAXAMSSXMXMAS
MXMMMMXMAMMMXMMXXASAXXXMMXMXSAMSSSXSSXASASXMMMXXXMASAMASXMASMSMXAMXXSAMAAAXAXXXASXSXSAAAAMAMAMAAMMMAAMAMMSAMXMASASXMSSSMMMAAASMSMMXSAXAMXXSX
SMMAAMASMSAMXMXMMAMXMASMSMSASXAMAMAXMAXMAXXMSSSMSMMMXSAMAXAAMAMMMSMMMMMMMMMSMSAMMAXMMMSSMMAXAMMMMASMSMAMASASAMAMAMAAAXMSMSSMMMMAXXSMMSSSMSAS
AAXMMSMSASXSAAAXAAMASAMAAAMASXSMAMMMMSSMSMSXMAMAAXXAMMXSMMMXSASAAAXAAXAXAAAAAXAXMASXMMAAMSSSMSMXSASAMXASXSASASXMAMMMMMXAMAXXXSSMSXMAASAAMMSA
SSMSAAXMAMASMSMXSASXSAMMMSMMMXAMXMXAXAXAXAXMMSMSMSMAMAMSXSXASAXMSMSSMSMSSMSSSSMMSXMASMSSMAMAMAAAMAMAMSXSXMASXMASASASMXSSSMASMMAXMASXMMSMMXAM
MAAMSSMMAMXMXXAXXXMASAMXXMAMXMSAMXSMSMMMMSMSXXAMAMMSMSSMASMXMSMXAMXAXXMAMXAAAAMAMASXMAMAMXSAMMMMSMSSMMSXXMAMASAMXSASXAMAAXAMASMMMAMAAXXXSMMX
SMMMAMASXSASXMASXMMMSSMXMXXMSAMXSXMXAXAMSXAMAMAMAMAMXXAMXMAAMXSMAMSAMMMMSMMSMMMAXXMAMMMMMXMASXXMMXMAASAMXMXSXMMSMMAMMMMSMMMSAMXAXASMMMSMMAAX
XAMMASXMASASAXAMASMXSASMSXSMSMSASASMSMMXMMAMSMXSXMASASXMASMMMASMAXXAXSAMXAAXAMSXSASXSXMAMXMMMMMXMASMMXXAXMAXAXAAAMAMAAMAAXXMAMSASAMXASMASMMS
SMMSASAMXMAMMMAXXMAXMAMXXAXAXAMXSAMXXASAMMAAXMASXAASAMXSAMAAMASXMMSAMSAMMMMXAMAXSXMASASASASAAXXMXAMXSMMMAMMMSMSSSMASMXSASXMASAMMXMAXXASAMAAM
AMAMXSAMXMSMMSAMSSSSMSMMMMMMMMSAMXMMSXMASMMSSMAMXMMSASXMASXMMMMAXMASMMXMASXXSMMMMAMAMMSASAXMXMMSSSMXAASXMMSAXAAAMXMSAAXMMAAAMASAMMSMXMMMMMMM
XMAXMSAMAXMAXSAMXAAXMAXAAAAAAXMXMASXMAMAMAMAXMAMMMMXAMAMMMMASASAMSAMXXMSXSAMXAXMSAMAMXMAMAMSMSAAAAXSMMMAAAAASMMSMSSMMMSAXXMXSAMMMAAAMAAXXAAX
MAMSASXSXSXMMMAMMMMMSAMXMSSXSAAASASAMSMAMXMXXSASMMSMMSSMSXSAMXAMXMAMXMMSAXXASXSASXSMSXMAMXMAAAMMMMMXMXSMMMMXMASXAXAASMMMSMMMMMSXXSMSASMSASXS
MXAAXMMXMSASXSSMXMXAMMMSAXMAMMSASMSAMMSMSXMAMXMAAAXAAAMXXMMASXMMMSXMASAMAMMMAAAMXMAXAXXXMAMASMASXMSAAASXMXXMSSMMMSSMMSAAAAAAAAXAMXAXXAASMMSS
MSAMXMXSXSAMAMAAXMASAAAMMMMMMAXMSAXXAXAMXXAAXAXSMMMMMSMAMMSAMXXMASAMXMMSSMMMMSMXASMMMSMASAMMAXXXAASXSMMAXSAMXMAAAAAXASMSSSMSXSSSSMMMSMXMXXAX
AMMXSAAMAMXMAMMMMMSMSMASMASAMXMAMXMMXXAMAMMMXMMMASMXMAMXAMAMXXAMMSAMSAAAAAXAXAXXXMAAAAXXMAMAXMAMMMMAMXSAMSAMXXMMXSAMXSXAAAAMAMAMXAMASAMXXMXM
MMXAXMSMSASXSMMAAXAAXXMAXAXXMAMXMMXMASXMMSASXSASAASXSSSMXMAMAMXMXMAMXMMMSMMMMMSMSSSMSSSMMAMMMSMMSAMAMAMMXSAAMSXXAXAMMSMMXMMMAMAMXXMASASMSMSA
XSMMSAAAAXXAAXSSMSMSMMXMMMSMMMSMMMSMMMAAMSASASASXMAMXAAMXXMXMAAMMSMMAMSMXASXASAXAAMAMAMXSAXXAMAAMAXSSMSMASAMAAXMXSAMAMASAMXSXSXXXAMXSAMAAAMS
XMASMMMSMXMMMMMAAAXAXXAMAMAMAMAMAAXMASMMMXAMAMAMAXAXXSMMMMSAMMMMMAAMXMAASAMMMXASMSMAMSMASAXMSSMMSSMAAAXMASASMMXMASXMXMAMSMXXXMAMSMMXMXMMMMMX
MSSMMAAMXMSASMXMSSSMMSSMSSSSXSASMMSAAAAXMMMMXMAMMSSSMXXXAASXSASASXSMSAMMMASAMSMMXAMAXXMASMASASAAAMMMMMMMXSAMAMASAMXXSMMSAXMMMMAMAAXSAXMASAMX
AXAAXSSMAASASXAXAAAXMAMAXMAAXSAMAASXMSSMAXSAMSASXAXXAMMMMXSASASXSAXASMMXXAXMXAASXMSXSAMASXMMAXMMSXXSXXAMMMXMASAMAMSAXASMMXXAAXAMMSMMMMSASASA
SMXSMAXXMXMMMMMMSSMMSAMXMMMMMXASXMMXMAMAMXAAMXAXMSSMMMAXXAMAMXMAMAMAMAXXMSSMMSXMAMAXSAMMSAXMAMSAXMAMMAMXXAXSXMMSSMMMSMMMXMSSSSSSXXAXXAMMSXMX
XAAMMMMSMAAAAAAAMAMMXMXXAAXAMSAMAXSAMXXSXSSMMMMMMAMMSSMSMXSAMAMMMAMASAMXMAAAAXASXMSXSXMXSAMXSMMASXMAASMSMSMXAAAXMAAMAXSSMMAAXAAXAMXMMXSASAMA
MSMMAXAASMSSSSMMSAMXMMMMSMSMMMAXXMMXSMMXXMAXXXXASAMAMAASAMSXSASMMASAMXSAXMXMAMAMXAXAMASAMXSAXAMXMAMSXXAXAXASXMMSSSMSAMMASMMSMMMMMMAXMAMMSAMS
XXXSAMMXMXAMAAAASMMXAAAAAMAXXSAMSSMMAMAMXSAMSMSXSASXSMMMSXMASAXAAAMMMMSXSMMSMMAMMXMAMMMASAMMMXMMSSMMAMSMSMXMAAMAAMXMAMSAMMMXMXAAASASMXSMSAMA
MXAMASXASMSMSMMMSMXSSMXMASAXXAAXAAXSAMSSMMMXXAAASAMAXAXXXXMMMAMSMMMSAAMAMAAAASXMSMMMXXSXMXSXXSMMAXAMAMXSAMXSSMMMMMXXXMMXMASAMXSMMXMAXXAASAMM
AMXMAXMMSAMXXAXAXMAXAASXMMMSSSSSMMMMAMAMMAMMMMMXSAMSMMXMAXMXMSMMAXAMMSMASXMMMMAAAMASMMMASMAMMMAMMSSMXAXXSXMAMXSXSSMMAXXXSXMASAMSASAAAMMMMASX
SSMMAMSAMAMMSSMMAMMSMMMAAXSAMMAAXXASAMMMSASXSSXASMAXMASAMMSMMXASMMSSMMMXXMSMAMMSMSASAASAMXAAMMMMMAAXMAMAAXMMMMMMMAASAMMMMSMAMAMAMSMMSSSMSAMM
XAMXMAMASMMXAXASXAAXMASMMMMASMSMMMXXASAAXMSAMXMXSAMXMMMXSAAXAMAMXAMAXMMMSAASXMXXMMMSMMXMMXMXSAMAMSXMMAMAXMASAMSAMAMMASXASAMXSAMMAXAXAAAAMSSX
SXMAMMSXMMMMMXXMAMXSMMAMXMMAMXMMMMSSMMMSSMMAMAXXXXMASXAAMXSMSXMMMSSSMSAXMSMSXMASMMAMMSMSAMSASAXXMAMAXXSSMAMSAMSASXSSXMMXMMSMSASXSXSMMMMMMMMM
MXSASMMMXXASMSSSXSSSXSXSAMXSMMMAAAXAAMAXXAXMMSSMMMSXSMMXSAMXXAAMAMXXAMXSMMXSAMAXAMSXMAAMAMSASMMMMMASAMAMAMMMMMMAMAMASMSXMXSASMMAMAAAXAAMXXAM
XAMXXAXSASXSAAXMASXMAMASMMAAAXSSMXXMMMXMSSMAAXAMAAAXXAAAMASASMMMMXXMSMAMAAAMMMXMXMXASMSMSMMAMXSAAXXMMMASXSXSXXMAMXMAMXAXSASMSAMAMSMMMXSXSMAM
MMSMMSAMASAMMMMMMMAMAMMMXMMSMMXMAMSXMAXXAMSMMSMSMMMSXSMSSXMAMAXMMSAAAMAXMMSXSASXMASAMAMXAAMXMASMSSSSXSXMAAAMAXSXMXMXSXMSMAXXXAMXMASAMXXAXMAM
MSAXAMXMAMAXSAXXASXSASXSXSMAXMAAAASXSASMXMAXXAXAAXSMMAAXXXXXSAMAASMSSSMSAAXAMAAMMXMMMAMAMAMXMASXAAAAAMMMSMMMMMMASAMSSMXAMXMMSMMSMAMXMAMAMSMX
MSAXXSXSXSAMSAMSAMASXSAMAMMAMMMMMSMAMMAAAXMMSSSMSMAASMMMMMXMAMSMMSXAXAASMMMXMXMASAAXMSMSAMXMMXSXMMMMXMAAAAXXMAMAMASAXAXMSMSMAAAMMAMAXAMXMAMS
XMSMAXASAMMMMAMMSMAMAMXMAMMSSXSASAMXMSMSSMSAXAAAXMSMMAAAAAXMMMSAMMMMMMMMXMXMAMXASMSXMMAMMMASMMMMXSAXAMMSSXMSSXMMMMMMSSXMAAASMMMXSASMSMXAXAXA
XAAMXMXMMMAAMXMAXMAMAMAMASXAAASXSAMXMXXXMAMMSSMMMAMMASMSSSMSAAXXMAXXAAAXMMAMAMSMMMMASMAMXSAMXAASASMSMSAXMAMXAASMMSAXAAASMSMSXXAXSAMXAASXSMSM
MSMSXMXXXSSSSMMSMSSSMSASASAMMMMMSAMSSSMMMMMMAMAXMAMAAXAMAMASMMMASXSSSSSMXSASAAAAAXSAMSXXXMSSXSSMASAAAAMASMMMMMMAASXMMSXMAXXSXSAAMAMSXMAMXMAX
MAXAXXMAXMAAAXAXXXAAASXMASAXMASASAMAAAXAASAMMSMMMAMMMMAMAMMMASMMMMAAAAXMAXMSMSXSMMMMMMMSAAMMMMAMAMMMSMSAMXAAASMMMMAXXXAMAMXMASXMSSMXMASXSSMS
MMMAXMSSSXMSMMAXMMXMMMXXXMXMSMMMSXMMXMMSSSMMXAXMMSSMMSSMSSMMXMASXMMMMMMMMSAMMMMMMAAXXAASMMMAMSAMXXSAMXMAXSMMMMAXXXSMMMAMXXAMXMAMAMXMXAXMMAAA
MXSAMXAAAMXAXMSASAXSASMSSMMXXAMXMMMSAMXMAMXASMMSAMAAXAXXAAASASMMAMAMAMAAXMAMAXAASMSSMMMSXXSAMMSMMMMMSASAMMASMSMMSAAASXSMSSSXASXMASAMXMXASAMX
AAAAMMMSMAAMXMMAMAXSASAAAAMMSSMAXAAMASMXAASAMAAMASXMMMXMMSMMXMMAMSAXAMMSSSXMMSMMMAAXMAMXMXMXMSAXAXAXMMMMSMAMAASASXMMXAASMAMSXMXSSXXXAMSMMMSM
MMMMMXMAXSAXAMMXMSMMAMMMSMSAAASXMMSXXMAXXAMAMMMSMMXAAAASXMXSAMXSXMMXXXAMXXAAAMASMMMMMAXAMSSMSAMMMSMSMAAAAMAMSMMMSAXAMSMMMAMXSMMMAMSSXMAMAAAX
SXXSXMXXXMXMMSMMMMAMXMSMMAMMSMMSMAXMMMSMSASAMXAMXMSSMSXSAMASMSMMMXSASMSMASMMMSAMAMAAXMSXSAAMXMXMMAMAXSSSMMMXXASASAMXMAAMSMSAMMASAMXAXMXSMSSS
MMMSAASXMSSMMAAAXSAMSXSAMSMXXXMAMASMAMAAAMXASMMSAMMMAMXMAMAMXSXMAXMAMAMAAAASAMASMMMSSMAXMXSMAXAMMAXAXXAAXSSXSAMASXMAMXXMAXMASAAMASMMMSAMXAAX
MAAMAMAAAAAMSSSMXMMMSASXMXMXMXMMMAXMAXMMMASMMXAMXXASMSMSSMSSMSAMSSMMMSMMMSMMSMXMASAAAMXMMAMMMXMSSSMXSASXMAMMMMMMMMXXSSMMSXSAMMSSMXMAXMAMMMXM
SMSXSXSSMMSXMAXXAAMAMMMXMAMASMMXMSSSSSSSMAMMAMMMSAASAAAAXAXMAMMMAAMSAAAXAAASASXSSMMSXMAMMASAXAAXAMAMXMMAMASAAAAAAXAAAAAAAMMXXXXAAASMSSMSSSMA
MAMXMAMMAAXAMXSSSSMASASAXXSAXASMXMAMAAAXMASMAMMAMMMMXMMMMSMMMMXMSSMMSMSMSXSMMAXXXMAAAXAMSXSASMSMXMXAAXXXMXSXXSSSSSXMSSMMSSSSXSSXMASXAAAAAXMS
MAMAMAMSMMSSSXAAAXXASXSASMMXMSMXAMAMMMMMMAXMXXMASXMXXXMXAMAMXSMMMXMAXXMXMXAAXMMMMMMSSMSMMAMXAXAMSSMSMSAXXMMXMAMMMAAXMXXAMXAXAXMMMAMMSMMMSMXM
SASMSMMXSXAAAMMMMMMXSAMXAASMMMASXSSSMXMMMASXMASASASMSSSMMSSMASXAASMSSSMAXSXMMXAAAMMAMXMAMXMAMMAMXAAAAMMMXXAAMXSAMMXMAMMMSMMMAMMXMXSAMAAMXMAM
AAXMAMAMAMMSMSXSAXSAMXMMMMMMMMAMAAAMXAXAAXSAAMMASAMAAAAXAAAMAXSSMSAAAAMSMMAAMSSSSXMASMSAMXSMXXASMMMMSAXSXMSXSASXSXSMSMAXSAMXAAMMMMMMSSMMAMAS
MMSSMMMSAXMAAMAMAMMASXSSXMASAMAMMSMSSSMSXMSMSSMAMAMMMXMMMMSMMMAMAMMMXSMMASMMMAXAXMSMSXSXMASXMSASXAAXMXXSAMAAMMSXMXMAMXSXSAXSASMAAAAXMASXXMAS
SAAAXXXSMSMMSMAMAAXMMMAMMSASAXXMAXAAAAXXAMXAMMMMSMMASASXSAXAXMAMXMSMXMAMMMSAMXSMMMAASASAXMSAAMXMMMMMMMASXMMSMMXMXAMAMMMAXAMXXMXSMSSXSAMMSMAS
MMSSMSMSMAXMXMASASMSAMAMAMASXMSSMMMMMMASXMMSMXAMAMMXSAMASAMMMSMMAMAXAMAMMXMSAXXXASMSMAMMMAMXMASXSXSAXMXSAMXAMAAMSAMAXAMXMSMSMMAMXAAXMASAAMAM
XAAAXAAMSAMMAMXSAAASMSSSSMAMXXXAAXAXSXMAAAAMMSMSMMXXMMMAMXMAAAASASMSXSSMSAMXXMSSXSXXMMMXMSASXAMXMASAXMAMMMMMMMMMMASXSMSAAXAAAMAXMMMMSSMXXMAS
MMSMSMSMMMXMASXMMMMMMSAMASASMMSAMMMMXAXSMMXSAAAAMMMXAAMAXASMXSMSXXXAMXAASMSAMAMMMMXMASAXXMASMMMAMMMMSMMMAAAAAAMAMAMAAMSMMMSMSMSMXSAAXAASMSAS
XMAXAMMAMASXSMXSXXAAXMAMASMSAAXAMXXSSSMMXMMMMMMMXASXMMSMSXSAAXAMASAMAXMMMXAXMSMSASASAMXASMAMAMMMXMAMXAASMSSSXSSSXMSMMXXAAXXAXAAXXAMXXMMMAMAS
MSMSSSSMMAMXAAXSXSXSMSXMAXAMMMSXMXSAXXAXMXXAAMSSMMSAAAAXSXMMMSAMAMAMSSXMXSMMMMASASAMASXAXMAMXSASMSMMSSMSAAMMAXAXAASXXXMSMSMSMMMXSASASMSMXMAM
MAMAXMASMXSSMMMSAMXXXSAMXMSMMMSAMXMMMSSMAMMXXMAAXASXMMSASXXAASAMXSXMAXAAAXXXAMMMXMXMAXMXXSXXASASAAAAXAXSMMSMSMAXMXMASMXMASAAAAAMXAMASMAMSMXS
SAMMXXAMXAAAMAAMMMMXAXAASXAAXAXAMMAXAXXMSASAMMSSMAXAXAMMXAMMMXXXXAMMXSXMAXMSXSXXXMSXMXSXMASMXMXMMMSMSMMSAAXMXMXMXAXXAMXMMMSSXMSMMXMAMXAMMAMA
SXSXMSSMMSMSMSAXXSXMMMMMMMSMMMSMMMAMSSSXXXMAMAAAAXSSMSXXXMASAXMAXMXMAMMAXAAXAAMAAAMAMAMAXAXXXXMSSMMAXMAMMSMSAMSAMXXASXSXAMAXASAMXMMASXMSMAMM
XAXXAAAXAAAAAXXMXAAXAAXAXAAMAAAMXMAXXAXMMMSSMMSSMXMMAXAAXXXXMSMSMAMSAMAAXMMMMSASMMSSMSSSMSSSSMMAAAMMMSSXAXMSAMXXMSAMMAAXXMASXMAXMASMSMAAMASX
SMMMMSSMXMXMSMMMSSSMMSSXSSSSSSMSASXSMMMMSAAAXAAMMMAMAMMMMMMAXSAMXAAMAXMSXSAAAAMAAAAAXMAAAAAAXAMSSMMSASAMXMAMMMSMMMAAMXMASMMMAXAMSAMASMSMSXSX
AAXMAXAMASAMAAAXAAAMAAXXMAMMMAASASMXAAXAAMSSXMMSASAMXMXMAAXSMMAMSSMSMMXAAMXMMMAMMMMXMMMMMMMMMSAMXMAMMMMXSMXMAASAAMXMXSXXMAMXSMAXSAMXMAMXSXMM
MXMMMSAMASASXMMAMMMMSXSMMAMASMMMAMXSXMXMMMMMXMMSASXMAXSSSMSAASAMXXAAAMMMSMMSSSSXSMMSMMAXAMMSXXXSAMXSSMSAMMAMMASXMSMSAMMMSMMAMXSMSMMAMAMXMASA
SMSMAMMMXSXMASXSSSSXXAMXAASXSSMMMMMSXSASXAAMSXAMMMAMXXMAAXAMXMAXAMMMMMXXXMAAXAMAMSAAASMSAMSAMXMMMSMAMAMMSSSSMMSMMAXMASAAAXMXXAMAXXMMSMXXSAMA
AAAMASXSASAMSMAMMASAMXMXSMSASAXXXAAXASASXSAMMMSSSSMMSSMXMMSXMSSMXSSXSMXMAMMSMMMAMMMXXMAAXSXMAXMAAAMAMXMAAAXXMXSASMSAMXMMMSMAMSMMMXXAAMAMMMSM
MSMSMSAMASMMAMAMMAMXMMMAMAMXMMMXSAMMXMXMXMAXXAXXMAXAASMXSXMAAAXMASXAAAXMAAAAAXMASXSSMSMMXAMXSMMMSMSMSMSMMSMXSASMMASMMAAAMXMSSMAAAAMSMMMMAXAM
AXMXMMXMAMASXSMSMXSSMAMAXAMXAXXXXASXSMXMASAMMSSMSSMMMSXAMASMMSSSXMMSMMXXMSSMMAMXXAAXAAAXSXSAXAXAMMSAAAMAMAMXMASXMXXASMXSAAXMAMSMMSXMAMXSMSSS
MSXMSSMMXXXMAMMMMAMMSASXSSXXMMMMSAMAAXXMASMMMAAAAXAXAXMMSAXSAMXAAXAMAMXSMMAAMSMSMMMMSSSMAAMASMMXSAMMMMSAMMSSMAMAXXMMMMAAMXMSMMMAAXMSMSXMAMAM
XAAMASAMSSSMASAAMASXSMXAAMMXMAAAXAMSMMAMASASXSXMSSMMSMAXAXXMXSSSSMSSSSXAXSSMMMAAXAXXAAMXMMMMMXAMMMMXSXSMSAAAMSSSMSXSAMMSXAMXSASMMSAAASXMAMAS
MASMASXMAAXSAMXXSASXMASMMMAAXXMSXMMXAXXMXSAMAXXMAAXAAXSASMXSXAAAMMMAXAMMMAMAAMSMSMSMMSMXSXXXMAMSAXSXMASAMMSSMAAAAAXSASAMMXSAMXSAMXMMSMASXSSS
XAMMAMXMMSMMXMAXMASAXAAXXMSMSAMXASMSXMMMAMAMAMAMSMMSSSMAXMASAMMMMAMXMMMXMASXMXAMXAXXMMMAMMSSXMASMSMAMAMSMMXMMMMMMMXSMMASAXMASAXAMAMXAXAMXXMM
MSSMMSXSAMXAAXMXMASAMSSXSXAAXMASXMASMAAMXSXMASAMAXAXMAMAMMAMMXMASXSXMXSXSXMAMXMMMMMMAAMMMAAMAXMMMAMAMAMMSMXXMXMSMMMXAMSMXXSAMXSSMSSMMSMMMMMM
MXAAAXXMSSXMMXMAMASXMXXAAMMMMXMMSMXMASXMAMASASASMSSXXAMAXMMXSASXSASAMAAMAMMSMMAASAAASXSMMMSSMMSMSSSSSMSAAMAXAAXXAAXAMMMAXXSAMXMXAMXMAAAASAMA
MXSMMSXMMMAAAAMMMASAMXMXMXAMSAMSAMXXXXAMMXAMASAMAAMMSXXMXXXMMAMAMAMXMAXMXSAMXMSMXMXXMXSAASAAXAAMAAAAAAAMAXAXSSSSSMSSXXMAMMXAMXXMXMAMSSMMXASX
XAXAXAXSASXMSXMAMXSASXSASMMXSASAMXSXSMSMSAXMXMAMMMXAAMSXXMAMMSMMMAMSXAMMAMAXXMMMSXSASASXMXXXMSXMMSMSMMMSSMMXMAMAAAAAMMSASXXSMSXMASXXAMMMSMMM
MASXMAXSAXXXAMMSMMSXMASASXMASMMASAMMSXMAAMXMXMXXXAMXSMAASMSMAMAXSSSSMSAMXXSMSXXAAAMAMXSAMSMSMMMMAAXMAXMAMAMSMAMXMMMXAASASAAMAMMSASXMAMSAAAAX
XMAMASXMMMSMMSAXAASXMXMAMMMAMAXAMASAMXMMMXSMASMMMSMSAMMSMAAMMXSMAXXXAXXAMXMASAMMMSMMMXSMMAAAAMAMSSMSAMMMSSMMSXMASMSMSMMAMMMMAMAMXMAMAMMSSSMS
MMXXXXAMSASAAMAMMMSASXMMMMMMSSMMSMMMSXMASMMMAMAAXAMXAMXXMSMMXAXMXMMMSMSSMXMAMXSAAXAASMXXSMSMXMAMXAAMXMXAAXAMXSSXSAAAXMMMMSASXMASAXSMSMXAMXXM
MSMSMSMMMAXMXMXMSMSAMXXAAXXMAAXMAMSMSMSAMAXMSSSMMMSSMMXXAXAXMMSAAAXAXXAASMMMMAMMSSSMSAXAXXMAXSASMMMMXXMMSSXMAXXAMAMSMSMSASXSXXSXMXXAAMMASXMS
SAXAAAXSMSMSMSMAXAMAMASXMMSMMSMMAMAAXASASMSXAAXMSXAAXSMMMSSMXMAMAXMASMSSMXAXMXXAMXAXMMMSMMMSMSASXMAXAMMMAMMMMXSAMXMXAXAMAMMMXXXAMAMMMXSAMAAA
SMSMSMSXAXAAAAMXMAMAMXMAAAXXAAASMMMSAMMAMXAMMMMMXMSSMMAAMAMSXMXSXMSAXAXXASMSAMXSMMSMXXMAAMMAMMXMAXAXXMAMMXMAXXAAMAXMSMSMXMAAXXMAMAXAXXMASMMM
SXMMAXXMAMXMSSSMASXXXAMSMMSMSXXAAXAXMMMMMSMXSAASAMMXMMSMMAMMXSAMAXAMMMMMXMXXAXAXAMAMXMSSSMSASXASXMSSSSSXXXSASXASMXSAMAXAXSMMSMSAMXSMSMSAMXAX
XAMSSSMSASXXAAAMSMASXSAXXMMMMSMMMMXSASAAAMXASXSMASXAMAXAMSMSASMSAMMXAMMMAMXSMMMSAMXXAAAAXAMAMMMMSAXAAAAXSXMASMXMASAMSAMMMMAMMMAMMXAAAXAMMSMS
SXMAAMASASMMMSMMAMXMAXMMMXAAMXXSXMMSAMSMSSMMSMMMAMXXMASXMAAMASASXMXSMSMSASMMMAXAXXMSSSMSMMMSMAMMMMMMMMMMMAMAMAMMMMAXMAMXMSAAASASMXMMMMMMAAMM
AAMMSMAMAMAAAMXSMSSMSMMAAXMSSMMSAAAMXMASAXMXSASMXMMXXASASMXMXMAMAXXMXAAMAMAAXSSMMSAAXMAXAMAAASAMASAXSAXASAMMMSAAMMSMMAMXXSASXSASASXMSSSMSSSM
SXMAXMASAAXMSMAMXAAAMAMMMAMXAXASMMMSAMXMXXSAMMMXXSAXMXSAMXAXAXAMSMAAMMSMXSSMMXAAASXMXSXSMMXMXMASAMXXXAMMXXMSAXSMSAAMSMSSMXAMXMAMASAXAAAAAAAX
MMXSXSMSXSXSAMSSMSSMMSMAASMMMMXSAMXSMXSAMXMAMSAASMSSMAMAMSSSMSMXXAMXAMXMAMAASMMMMSAXXMXAMSMSSSMMMSXSXSXMSSMMSMXMMMSXAAAXMMMMXMXMXMMMMXMMMSMM
XAAXXSXMAMXMASAMMMMMAMMXMMAAXMASAMXMAMXMAXSAMMMMAAXXMAXXMAAAAXXAXAXMSMAMASMMMAAXAXMMAMMSMAASAAXAXMAMAXAMAAAAMXMASXMXSSMMXAAAXSASAAMMXMAXXMAS
MMMSASXSSMXSSMASXSASASXAXMSMXAMXMASMAMMMSXMXSXSXMMMSSMSXMMSMMMMMSMMXAMAXMMMMSXMMMSXMAXAXMXSMMMMMSMSMXXAMSSMMSAAMXSAAXAXXSSSSXXAMSXMAASXMMSAS
MAAMMMAXAAASXSXMASAMASXSSMASXSMMMXXMMMMAMXMASAAXXAXMAXAMSXMMAAAMAMASMSSMSAMASAMAAAASASXSMSAMXSAXSAAMMXSMMAXASMSXAMXMMMMMAXAMXMSMXSMMMSXAXMAS
MMSSXMXMMMMSAMSAMXXMMMMAAMAMMXAXSAMXSMMASAMAMSMMSAMSMMMXMAASXSMSAMAMXXAASAMASASXMXMMAMMAMXAMAMXMMAMXSAMASMMASAMMXMAXMAAXMSSXSAAAXXSSSMMSMMSM
AXAXAAAMXMXMXMAMXMMMXAMSSMMMASMMXMMASAMSSXMAMMXMMMAAMASASXMMXMASAMSSSMMMSAMXSXMAMSAMXMSMMSAMSSMSMMMAMASAMXXASXMAASXSSSSSXMAAMSMSMAASAAAMMMAM
SMXSASASAMMMMSXSXMAMXXMAMASMMMXAMXMAXAMXXMXMSSMSAXSASXSASMXXAMMMAXAAMXXAMAMXMXSAMXMAMXXXASMMAMXAAAMXSAMASAMXSAMXASAXXMXMAMMMMAXXMSMSXMASASAS
AAASAMXMMSAAXAASXSAMXXMASAMAMSMSASMMSSMMMSSMAAMSAMMMMAMMMMMSXSXMXMMXMMMSSMMSAAMAMXMSMSMMMSAMASMSSMMXAMXMSASAXAMMSMXMXMMSAMXSXXSXAXXMAMXSASAS
MMMSXMMXASMSMMXMMMXSAASXMMSAMAAMXMAXAXAXAAMMMSMMMMAAMAMAAXXMAMAMSSXMMXAAAAMMMMXAMXXAAAAAXSAMXXMAAASAMXMASAMAMSXMAAMSSMAMAXAMXXXMXMXSAMXMAMMM
XAAMAXMMMSAMMMAAXAAMXMMASXSAMMMMASMMMSSMMSSXMMMMMSMMSASMMSAMASAMAAXAXMMXXMMXMASASXSMSMXSXSXMXXMMSMMAXMMMMMMAMMASMSMAAMASMMSMSAMXAMMMMSAAXMAX
SMXSAMXXXMAMAXXSMMSSSXSXMAMXMSXSASAAAAXXAMMXSAMXAAAMSXSMASXSASXMMSASMSMSMXMXXMAMMAMAAAMMASXASXMAXMSMMSAAAMMXMSAMAAMSSMXSXAXAMMASXAAXMXAMMSXS
MAMAMMMMSSMMSXSAMMMMMASMMMMAXXAMASMMMMMMXXSAXASMSMSMMAMMAMXAASXMXMAXAXAAMAMSMXMASAMXMSMMAMMAXAMAMAXSASXSSSMSAMXMASMMAMAMMXMAMMMAMXXSMMSAMXMA
MAMAMAAAMXAAAXAMXAAAMXMASXXSXMMMAMXXAAAMAXMMSXAAAXXXMSMMMSMMXMAXAMXMMMMMSAXAMAMXXAXMXXXMMMAMMSMXXAMMXSXMAAASMXSAMXMMXMAMMMSAMXSSMSXAAAXAMASX
SASASMSSMSMMSSMXSSSMSASXMMMMMAAMMSMSSSSSMSSXAMMXMASMXMASAAASXSMMSSMMXSAASMSMSASXSMMSAMMSSMSAAXAXMSMSMSAMSMMMSASASXSSMSXSAAMAMAAAASMMMMSASASA
SASASMAMMAAAAAXAXAAASASXAAAAASXMSAAXAAAMAAXXMAXAXMAAASMMSSSMAAXAAAAMASMMMAAASASAAXXMASAAAAAMSMXMAAAAASMMAAAAMMSAMXXAAAXMMMSAMXSMMMMSAMXXMASM
MXMXMMSMSSSMSSMXSMMMMSXMASMSXXAMSMMMMMMMMMSMXSSXSXXSASXXMXMMSMMMSSSMXSXXMSMMMSMMMMXSAMMSSMXXXXMASMSMMMMASMMSSXMXMASMMMSXMASASXMXMASXXSAAMMMX
"""
