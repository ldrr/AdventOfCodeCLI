//
//  puzzle2419.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 19.12.24.
//

import Foundation

class Puzzle2419 {

    let patterns: [String]
    var patternsByLength: [Int: [String]] = [:]

    let towels: [String]
    var impossibleTowels = Set<String>()
    var cache = [String: Int]()

    init(data: String) {
        let data = data.components(separatedBy: "\n\n")
        patterns = data[0].replacingOccurrences(of: " ", with: "").components(separatedBy: ",").map { $0 }
        towels = data[1].components(separatedBy: "\n")
        patternsByLength = Dictionary(grouping: patterns, by: { $0.count })
    }

    func part1() -> Int {
        self.towels.filter { countPossibles(towel: $0, stopAtFirstMatch: true) > 0 }.count
    }

    func part2() -> Int {
        self.towels.reduce(0) { $0 + countPossibles(towel: $1) }
    }

    func countPossibles(towel: String, stopAtFirstMatch: Bool = false) -> Int {
        if towel.isEmpty {
            return 1
        }
        if let cachedCount = cache[towel] {
            return cachedCount
        }
        if impossibleTowels.contains(towel) {
            return 0
        }
        var newCount = 0
        for length in patternsByLength.keys.sorted() {
            guard towel.count >= length else { break }
            for prefix in patternsByLength[length]! {
                if towel.hasPrefix(prefix) {
                    newCount += self.countPossibles(towel: String(towel.dropFirst(prefix.count)))
                    if stopAtFirstMatch && newCount > 0 {
                        cache[towel] = newCount
                        return newCount
                    }
                }
            }
        }

        if newCount > 0 {
            self.cache[towel] = newCount
        } else {
            impossibleTowels.insert(towel)
        }
        return newCount
    }
}

func puzzle2419() {
    let puzzle = Puzzle2419(data: data)
    print(puzzle.part1())
    print(puzzle.part2())
}

private let singleTowel = """
rrgbgg, gbgbgr, rrb, wrgggbb, rr, bgb, wbb, ruugr, gwugg, ruu, gubw, gru, bgg, uwu, bggwbrgw, wwugbr, ur, urb, bbb, rrbrbw, uww, wggwwu, wwrb, gbg, wuruu, wbgbwbr, ggu, grgwru, g, uugbuu, rwrrwb, uurwub, grgr, wubb, buwu, guu, bbw, rgwgbg, grr, uuuwr, ggubrrg, uuub, gugu, bur, bguub, rgr, bwu, bwbuw, wwwwbw, uurbbgb, rwb, uuw, ggurug, wrr, gww, rgbgu, wgr, rw, uguu, brb, ugrr, brwurgu, rugg, gbuwr, gb, uggbrbr, urwrbgb, rbgwbwb, gg, rur, uuu, wr, grur, uwugb, gbrugru, buug, bbrw, uurugru, u, bb, ubggb, brrb, rrg, bgur, gubub, gwwu, rugurug, ggbgbgbb, ggbwgr, gurw, gbgww, ugbg, gugb, grg, rggwg, buwb, wbu, guwu, rggbgugw, ggb, ruub, rugw, ugb, wrw, www, gwwbr, bru, bgurrbru, rrug, wubgug, brguw, wbugr, ggur, rgwuurrw, wurrg, rrgu, wwrwrb, brg, wwg, ugugu, ugr, rbgr, rg, uggg, rgrg, wwb, rrgrrwg, bgwb, brgbwgu, rurg, brw, brww, brggu, rgwwbbgg, uwgb, rwgggwwb, wrgrbw, bwrgw, wbbw, rbub, gbguuuub, bwrwg, uurruu, rugu, urrwguw, bwru, bu, wuub, ugggr, uuug, gu, uugggb, wbbb, rrr, b, rgwgr, gbr, gwrwwrw, ugu, ggw, wgub, wuw, uubr, ggrgbg, uwbbu, ubwurb, rbb, uur, uwrruug, wrggur, bwrr, wugb, wuwr, wwgb, wgubgg, wg, rgwbgwbw, rggugug, uub, uggug, wgu, brgrrub, rwwrgbr, gbgrgr, grgubbu, ugbbr, urw, ubuubb, burgw, ubu, gwgub, wwwubrgu, wwwww, bgr, bgu, gwwruuw, wgrgw, uwuu, wrb, ubw, rgrwu, brrrrr, wrgbb, gwuuwbg, wwbgu, uugbwrww, brwbg, ub, rbru, ruggwr, gwb, ggwrgg, ggurur, rgrrwrbw, wrgw, bugg, gbu, rgu, rwuw, gwg, uuwwu, uwbwww, wuwwbuu, wb, bbrr, rgrgwru, burr, ugurubu, gwu, buurb, wrgg, bugbrw, burbuw, bwr, urr, grgu, ruw, ugbwgw, rbrug, uuugr, buubwr, rurwg, ugrgw, grru, uwwwbur, uuwu, gwrwr, uruuu, urwgugbb, wrurwur, rwr, rgb, brbub, gwr, gwbb, brrbwb, bwwgw, bguw, ug, rru, wrg, uurrg, rww, bbu, wgbb, grw, ubg, uwg, ww, gbwr, rrwugr, wrrgwb, rrw, wbuuuub, wrurggr, bwrb, bbrbrgg, ggggbrw, ugug, wur, wwbr, gubbrwur, wgwgwb, wbbrr, wgw, rbwwbr, w, bbgw, urg, wbgbg, wbr, bbwbw, uu, wgwguw, wu, bgwgu, wub, buu, rb, bgbw, bgwgb, uwgrbu, guw, rbbgu, wru, rubgggwu, gur, rbrgw, gwug, wguwrr, gubbr, rub, rbwu, rgg, bggug, bwugb, rbbbgr, bbbwg, guwrrb, grrggg, bgwu, uuwbru, bbg, rug, uugu, gwugwu, ubb, gub, uubu, bwwrru, guub, wwr, urbgw, uru, wwu, wwwurwwu, bbwg, ubbbwg, gbug, bwbr, wgggwg, urgwub, bub, bg, uwrg, uwr, ubrrb, bug, rggru, rbw, ggrw, bbwwg, gr, gubu, uubbg, bwg, urggw, uuwrrgw, ugg, bbrg, gug, bwggww, grbb, bbbu, rbu, ru, ubuggr, ruuu, uug, uwb, wwwbug, uggwr, gbwuw, grwr, uwuwgbub, wwbw, bww, rbbwwr, bwww, ggggu, ugw, bwwwu, uuwug, wbbggrg, bwb, grbrgwu, bwwu, bw, ruurr, wbg, ubrg, uwuw, brrg, brwuu, gugw, urbggb, bruw, wbwuggw, ggwwr, rbwr, wbrgr, uugg, bbru, ugwuguwu, rwrg, bgwwwrw, uugwg, bwurrr, bwrwr, wwwrggu, bbr, rruwu, rgw, buw, urbrbg, wgg, gbgb, rwu, gubbu, gbgbgbrr, wbw, ubr, wgb, gw, buuwbr, rugrrur, gbuuwwr, rburubg, gbb, ugrgr, wug, ggggb, ggru, brwwg, bwwgrb, gurwubww, ggg, bwgb, bgugbw, rrrww, ggr, gbbb, bgw, bugu, wuu, grgur, rwg

rugbgbwwbbgrwrbubgugrgbrrbgwrbbgbwurwgrbr
"""

private let data = """
rrgbgg, gbgbgr, rrb, wrgggbb, rr, bgb, wbb, ruugr, gwugg, ruu, gubw, gru, bgg, uwu, bggwbrgw, wwugbr, ur, urb, bbb, rrbrbw, uww, wggwwu, wwrb, gbg, wuruu, wbgbwbr, ggu, grgwru, g, uugbuu, rwrrwb, uurwub, grgr, wubb, buwu, guu, bbw, rgwgbg, grr, uuuwr, ggubrrg, uuub, gugu, bur, bguub, rgr, bwu, bwbuw, wwwwbw, uurbbgb, rwb, uuw, ggurug, wrr, gww, rgbgu, wgr, rw, uguu, brb, ugrr, brwurgu, rugg, gbuwr, gb, uggbrbr, urwrbgb, rbgwbwb, gg, rur, uuu, wr, grur, uwugb, gbrugru, buug, bbrw, uurugru, u, bb, ubggb, brrb, rrg, bgur, gubub, gwwu, rugurug, ggbgbgbb, ggbwgr, gurw, gbgww, ugbg, gugb, grg, rggwg, buwb, wbu, guwu, rggbgugw, ggb, ruub, rugw, ugb, wrw, www, gwwbr, bru, bgurrbru, rrug, wubgug, brguw, wbugr, ggur, rgwuurrw, wurrg, rrgu, wwrwrb, brg, wwg, ugugu, ugr, rbgr, rg, uggg, rgrg, wwb, rrgrrwg, bgwb, brgbwgu, rurg, brw, brww, brggu, rgwwbbgg, uwgb, rwgggwwb, wrgrbw, bwrgw, wbbw, rbub, gbguuuub, bwrwg, uurruu, rugu, urrwguw, bwru, bu, wuub, ugggr, uuug, gu, uugggb, wbbb, rrr, b, rgwgr, gbr, gwrwwrw, ugu, ggw, wgub, wuw, uubr, ggrgbg, uwbbu, ubwurb, rbb, uur, uwrruug, wrggur, bwrr, wugb, wuwr, wwgb, wgubgg, wg, rgwbgwbw, rggugug, uub, uggug, wgu, brgrrub, rwwrgbr, gbgrgr, grgubbu, ugbbr, urw, ubuubb, burgw, ubu, gwgub, wwwubrgu, wwwww, bgr, bgu, gwwruuw, wgrgw, uwuu, wrb, ubw, rgrwu, brrrrr, wrgbb, gwuuwbg, wwbgu, uugbwrww, brwbg, ub, rbru, ruggwr, gwb, ggwrgg, ggurur, rgrrwrbw, wrgw, bugg, gbu, rgu, rwuw, gwg, uuwwu, uwbwww, wuwwbuu, wb, bbrr, rgrgwru, burr, ugurubu, gwu, buurb, wrgg, bugbrw, burbuw, bwr, urr, grgu, ruw, ugbwgw, rbrug, uuugr, buubwr, rurwg, ugrgw, grru, uwwwbur, uuwu, gwrwr, uruuu, urwgugbb, wrurwur, rwr, rgb, brbub, gwr, gwbb, brrbwb, bwwgw, bguw, ug, rru, wrg, uurrg, rww, bbu, wgbb, grw, ubg, uwg, ww, gbwr, rrwugr, wrrgwb, rrw, wbuuuub, wrurggr, bwrb, bbrbrgg, ggggbrw, ugug, wur, wwbr, gubbrwur, wgwgwb, wbbrr, wgw, rbwwbr, w, bbgw, urg, wbgbg, wbr, bbwbw, uu, wgwguw, wu, bgwgu, wub, buu, rb, bgbw, bgwgb, uwgrbu, guw, rbbgu, wru, rubgggwu, gur, rbrgw, gwug, wguwrr, gubbr, rub, rbwu, rgg, bggug, bwugb, rbbbgr, bbbwg, guwrrb, grrggg, bgwu, uuwbru, bbg, rug, uugu, gwugwu, ubb, gub, uubu, bwwrru, guub, wwr, urbgw, uru, wwu, wwwurwwu, bbwg, ubbbwg, gbug, bwbr, wgggwg, urgwub, bub, bg, uwrg, uwr, ubrrb, bug, rggru, rbw, ggrw, bbwwg, gr, gubu, uubbg, bwg, urggw, uuwrrgw, ugg, bbrg, gug, bwggww, grbb, bbbu, rbu, ru, ubuggr, ruuu, uug, uwb, wwwbug, uggwr, gbwuw, grwr, uwuwgbub, wwbw, bww, rbbwwr, bwww, ggggu, ugw, bwwwu, uuwug, wbbggrg, bwb, grbrgwu, bwwu, bw, ruurr, wbg, ubrg, uwuw, brrg, brwuu, gugw, urbggb, bruw, wbwuggw, ggwwr, rbwr, wbrgr, uugg, bbru, ugwuguwu, rwrg, bgwwwrw, uugwg, bwurrr, bwrwr, wwwrggu, bbr, rruwu, rgw, buw, urbrbg, wgg, gbgb, rwu, gubbu, gbgbgbrr, wbw, ubr, wgb, gw, buuwbr, rugrrur, gbuuwwr, rburubg, gbb, ugrgr, wug, ggggb, ggru, brwwg, bwwgrb, gurwubww, ggg, bwgb, bgugbw, rrrww, ggr, gbbb, bgw, bugu, wuu, grgur, rwg

rugbgbwwbbgrwrbubgugrgbrrbgwrbbgbwurwgrbr
uruuurbrwuwrrrwwurwbrwwguruwgrbgwbbwrugwwgrbr
ggrwuwgruurbwrgrgbwwgwrwguugbrwgwrrrrbrbrbr
gwwbbrugrggrwuuugggwgurbrurbrrggwwbgbwwbbrwwwurwwuu
uuwbubrwbgwwwbwrwbrubgwrwuwugrbrbbburbwwubuuburugwwguwwgu
gwgbububbgbgruwwrubbbgwuuubgububuwgwwrbwgwbgrbugbrbr
gwuuuuruuwurugrwubbuuuuggbrguuurwubuurgbgrrrugruggb
rgbbwbwgbguwubbbbuwrurugwbbgwbwwbruugrwrwbrwurwbbbrb
uubugbburruuuurrurwwuwgrwuwuwrwrwrurwrbbrubrrrbbgggruwr
wggguwwbgwrgubbbwwbgbwrwbgburruruugubrurrbwwgugwrrgrg
uwwwwbruwugburwubguwbbbuuggwbwugurrwwguwggurwbuwwg
uururrgbuwwgwuwurbugwbguuuubbbrruwbwrrwggrurbrbgu
uggwgrwguuwuwrwubbrwgwuuubrbuwgurbwwbuwgggrrbr
wrbwuwrrubbuubwubgwgbwuwrwwbrguguugbubgwwggurwuububbgwugur
uwubrgwwggbugbugggwubrwuuwwggurgwgggggguwrbuuwrrrbwuwub
rggbwgbgbrbgwubwggubbrwgbggugwrgwgggwwgrrrbr
bgburuuwruwwuuguwubwgubgugbrrbwrrbwwuurrwuwgub
rrugrwburgubgbrwbubrbgbruwrbruubgrgrwugwbggbubgrwrrburwgr
wuuuwbwburwrwubrgbbwrwbbuubbbgurgugruwwuwbuwwbw
grrwwrggbuwrbgbuuwrbgrgugrrururbbbwbwbgwbbwbrbgwguurubg
brurgwbuubwwwbgwgggwubwbgrbubguwuwugwwuugrbwgbgrbubwguurw
ugguubgrwwbwwwurbbbuubwbgubburgggbrbwrwwwgbrruubugrwruggrr
grwuwurwrwwrgubwuwwbwwgwbwggbwbuuwubbwurbubrwugwwbwuuwu
wgrbbrwuugbubwbbuuggbbwbguubbbwgwwubrrrgubgubuugbb
uwrbrgbrbbruwuurgbwrguwguuggwwwgbugbgwubwwbgwbwwguubrbrgr
ugugbrgurgguguwubwwuuwbwwbgguwbwwbwwbwrbuwuuwbbwwgrgbr
uwurwgugbbgbuugrwwggwbuwbbruwruugrgrgbugwwgwwww
rrgbbwuwgrwbwrrbbbrwuuggwgugbbbruugbuwguugbgubgrruugbwgwur
bbuggwrbgrwbwguggbrwggwbrbruguurrbuuubwrbr
ugrgububgrburrgbruwbugrguurugrgrbgwwwwbuggrbr
bgrbwbguwbrubbrguwugbgbuuruuubwrguwuubrugwbubrrwgwb
wuwrbgguuwwrgurgwwubuugwurgubrbrrwwbuugrrbr
bgbwbugubbrrwgbbbuububwgwrrbwwuugrrgwgrbr
bgwgbwggwbrbbgbggrrwgwbwwbrwgugrbuwbrububbg
ggggwgwuwubbwuwurbgbwurbguwbgrggbguuuubgrburwbwwbuwuwrgburbr
uuubwrgububwurrbwubrruugwrwgbggggwgrbrrwwrwbuuwwgrgbrurb
gbuwbwuwwgrggwuuuuuguuubruuwrbbrbrubbuguwbwuwbbb
wbwgubbgburrburbbuwbbbburwwwurwbwubrbrrrggrgugggurrbrbr
wburrbggburbuwugrwgrwwuuwrrgwgwuuurubbrwbgugrbggug
bgbgggbrwwgbubgrrrubwwgururggugrruwruurgwgbggw
gbrgwbbwgbbbburgbwbrwgruurwrgwuuruuurggggbuwg
gbguurubwgwguwrggrwwrurubwuruwrbgwrbburuwbuwuuwuurbg
gwgrbwwurguguugugggurggbbgguwrbgrrugbwwwwbrrbgwbuurbbwwr
ugwrbwugrbuwugububgbuugwuwuwgrggurbwwrbwrwrrbubrwwuurgwgg
urwrrwwuwguggubbgwwbrwrgwwuuwugruggbbgurrbrurrgbrrbr
brbrwurgbwrwruwrbbwgwgugrgubugwburgrwugrgwrrgugrugbgrugrbr
gurwwwuguurbrrguguwburwuugwwrbrrurguuubggrrgwrgggug
ugrwrbbrbuwuugrwuwwgwburubwwrgurrgbgwggwgbrbrruugbgwr
uguubguurbuuguwgwrbwrwbggurwgbrbwubrrurbrrrwbuwub
rwwrbgwgwburbubguwrurgwubbuwwguuubbrgwbruwrrbgwrgwr
uruuubwbbbwbrbgggwrwwubuuubrbuwrrbwbwgggwuuwrgbrwuuwbggr
wbgugbwuwrgrugggwwrwbgwbgbbbgbgugrbrrwgbgwuubuwwwgbubrbub
wbuurggbrggubbburbruugrgurgwuwwbggrrurbbugwrrwuuggrwurbr
guugwrwurggwugrgbwbuwwrgggrurbrruguwwuruwbgruwbb
bbuwbugrrbwgrubgbugugwwubbwgwwruguwurgggbubrr
wwbwrrgrrrwbbwrguwrurbbgrrrwgbbrgwbubgwwbuuubbrrwuugwwgwu
rbwbwrrurubrrwubruwururbwguwwbggwbrgwggwgguwwww
rwgrgwugrwwbrgruuwwwuugbrwguwrbbgrubububwgwbwurwubur
rurugbwurubbgrggwbubbwgbwrggwrgrurgbuwrubguubrubu
rbgwbruwrrwgguruwwrugugbwrurwwburuggwwwururbuurrww
guguruurrrurbrgrwugbrrwwrugguwwuruugwguwubr
urbggwrguubrwbwguubrrgwugggbrubbbwgggugrrgwrgwwr
wgurrbuwbrgrururuwgggrrugguururrggggrrgbbburwwugwguggrruw
ugburbggwwrwrbuuuuwbbrwrrrwruuuwbbbgurrugwgbubwgrgrrgw
bbgrgwbgwbwgrbbuwugwwguruggrgururgrwrwgugurbr
rwgwwbguwrwgbuwbrbrgrwuuuggrgrgbbggguruwuuugrrwbgggb
ruubbbuwuubrwuurwrgruwbgurubrrugrrgbuburwwurrbwrbwgubrgww
rwuurggurugbgwguwgbrwgbburuurrbugwrbgwbruuwwburbrbr
uwbbwurgbgggbwbrrwgbgburbugrrwurrbuwgbrwugrbr
rruwwbrruubrwrwrggwrgrgbuuruwguwrgbbrgbgguugrurgw
rgbuubgbrwwrbwrgwubggbbbuubgubruruwwgbrrwuuguubwwgrwbwu
uguugggugrubgruububbbbgwuwggwrgrwrrwwuwbuwbgrrrgwuggurruuu
rgbbwuwubrugbgrgbbrrgggrgbwrruuguurgrbwrrrwrwuggruwuuuww
bbwurwgrbggggwrrggbgrbgwwrrwggwwbuuruggwrggbwuwbwb
rgwbbwuruuurbrrbugwbguwugwrbrgugububrburwrgugg
rbuuwuubgrugwgwgrbwbrbubrbrwrgguwgbggbwuwbgr
bwgurrrbgurbbbuwbgrruuwrbggwbrgwbgrgrrggbrrrbuuwwgrurbr
wugwrwugbbrrrgrwrgruurgwwwgbgwwuubruugugguwrwruru
rwurgwugbuwwuggrwwwwbrbrrwwubbwrwgbrrwbrubrggrrwrgb
uwrbuubburubgubrruwbrbrubububrwgrburwuuurbruwwbbwguugwbr
wbguurugurbbubwgugrbbuurrbuwugrbubbrgrugrbgurrrgbbgb
brrburbrbrgrrwrbwrwbgbwrurrggbuuugbgwrwgurbwggb
uurbbuwgwwuggggubbrwwwgrwwrugrwguwgrurrbgrbr
uurrgbgbgbrrurbgbwwgurwbuggrwbuwrbbrurwrbr
wrggrbwbuwbrrruuwwwuubbgwgbgbuuwrgwgwbbguuugrbbwuwwr
gwuguuruwugbrururuubbuwgrrrrugugwgwgbrrwwrbbbruuruu
rubbgubbbbrwrrwwwrbbubugbgwwurgrbbgugurgbwgrgu
ruwurwgbruwwugggbgwbgubbgrbrubugbrrruuguwbgubrbgrgw
bbwgwgbbbrbwwruruuguwgrwwgrgwrbguwwbrruburruurbr
gugwwwuggrburwwbwwwgugwrbbrrggurrgwuburbruruwwgurbr
ugwbwgbuwwbbrrrrugrugwrwbrwwwugrgbrguwggwuwwrubgub
rurrgubbwgguwruggugguwrgrbwgrbbgurgwwbbggurubuurrgbbubb
rbwgwwgbrburwrwrbururwgguuwgwwwrbgwugguwwgwurwwgwgggururrbr
wbbwbbuugugrrgbgugbgubuububgrwrubggrwbwgrbr
gwugrgbwwurbwbrwrrrbrgwuwrrgbbwwugwggbgbgbbuuu
gwwbuwuwgbubgwgbgggrrgrwuwwugrurugbgrwrwbrgggbggwrrrgbwrb
ubbbwbrwgwubuwbwbgwgrrrurwgbuwwrgubggwuubw
wwbwgbgrwwwwwubbwrgrwbuubbwgbwuruwwruuwgbrwrw
gubbgruurrbwwgbwbbrbuuurrguwwuuggggrburgbgbgwrrbwbgbwurbr
ubwwbgrurwwbgrwbuubuuwuguurbruwgwbgbwbgbrruwguugwrwbbrurrr
brruwuugwgguurbguwruurrbwgwbruwuwgruuuwrgrbwuububrgwbwwgrbr
gwwbwugbrrwubwgugrrgrbrbggwruuuwrgubuugwuwugg
bgbbwrggwuwuruggbwurgubwwrrbwrubuuugbwwwwbbbrr
uurugwbbubrbwrruwrgruwwbbwrbuuuburwrbbbubrwrrruuuwrwwbu
wwbwuwbubwbgugwuuwbwbrurwwbrggwrbrggwgbugubwbwgrbr
brwgwrbguwuuggubgrrubbwubrrgrwwbrgubbrwubggrrrwurr
wruguuwbwgwwbwbwgbuggwbgbbbbrwuurggggbrbug
bbrwbubuuggbrgwbwwrurrruwugrrrbguggrggbbbuugbrrrubrbrbr
uwugugwwbbwwggrrrwgrwwubuwwgurguwruuguwwrggrwrbr
rbwbuuuwgguubrwgrggbbububbggurwubwwrwrwwrbbwubgguwgr
wuwwwuuwrgwuwgbbbguwrurwwggwuwwrwwgrbgbrrubbrrrwgwbwbw
ubuwburwrbgwgguuububugbwbrbgwgburgruububbrwrrugbw
wurbuwrwubwruggwwbrwurbrubwrggwwbuuuwuuugbwgwwgw
gbugbugrbbuuubgbrrwrwrbuguuuuuwburwbrbrrbwrbggr
gbwbggbbrurgwwwwgbwubbbgbrggbrbugbbgwbrbwwbggrugbbgg
ubgwurgwwurububwbwubgrbbrwugrrbgbbgrugrbbuwubu
uwwrubbgbggbguruwuuwrbubuwrbuwbrrwuuugrbug
wguubgbgbrrurwwgwbbbruwwbwggruuwwbrrrgwrbwgbuwrwb
ugrgrrbuwbwubgrrrbgrgbbwuuwugwggggwgrwrgurbgwuwuubgrubb
gbgggbwrbgrbrrbwgwbuubgbbgwuwbrrbwgugbggrbuuwbrr
grggugrguuwuugguwwuwrwrruwbbgugburwwgrgwgwrwugbugrgrbr
bbuwrbrgrbuuggbgbugugwruwbuwbrgurgurruuubuuru
grrgbbuwugrrggggwbgwbguuuubuwuurgwrwuggggrbrbbr
ggguugwugbbwbbbbubbuwwwuggwwugrwbruuuurggwbburrru
uwgwgurbburuuwrwggrrurgbruuurwrruwgwbwbgbubbwbggrbwrgub
gbgurrbruwbwbwrwbrrruwbbbubrbrrwgrrrrgburwbbuwrbuu
wuuuwubrwbggrwugbwbgruwbbuubgbguuwbwgbrwrrubuugggbwgrgrbr
brrruwrubrgrbgrububbugwwwrgbubwwbrbgggwbrgur
bguwgbbbgwbbbbgurwuguwuwbuwuwbgrrubrbgrrubrww
bgrbgwwbwbrubbubbbbbwbbrwrbrrwbwwguwrubgbwuwburgwbrurbr
uwugggbrwuwwrbuurggbwbwgurbrguggrugrwurrgugbrgwggwrguw
ubbrgggrrgwubbrwgwrwrgrururrbwwgbgurbrrrugubwwgbu
bugrwggwbwgbbgbgrugbbwurrwwrbuburuwubwbwwwwgrbr
rugguwururrgwwuwgbgrrbbrgrrbgrwuuggbbbbrgbbbw
rrgbrgurgwwwrrubgggwugwggrbgubwwggguurrwurbr
grgrwgbrrgbuwwrrrwbgrugruwrgurwugrggwuguru
gbububbrbrwubguurggurbuuwugrrwubwbbgugbugrrrrgubru
wrbrwwwuwwwwgubrwrbgrbgbrbbbbwruwrbbwrrbgwruubbrrrgwgg
urrububbruuuwuurubggbbrwrwwbbrwugubrgugurubbrr
ggubbgwwuuwurbubbgggbugugurwgwbrwgbrgrrbuuburgguww
rrrwwburwurubrrrrwwrbgwbbbuwuwrubbuguuubrbwrrbwgrb
rrwbwuruwbbbruwuuubggugruugwwbwbrbrrrwwgwbrr
wwbuuuwuurgbrgbugrwbguwgrrrbuuruuuwbwuwugbwb
ggbuwgrburbwrgbwbwgwurwurbbwbuwuuuwuguwrrrugu
ubwgbrbgugburggrrgburbrrbburggrugubwuurbgubbbwrburu
gwubgwwubwruwrgburwgwuugbgwbrgbgwbuwugbggrrgrrgrbr
ggbgbbgwbuwurrruuwuubuwwgwbbrbwrgrburwrwbbbbugrwrrurwwrbr
wrbggruwrwrbbwgurrbwgwwrwbgrggbrrugubugrrruwrgrwbbbb
wwwgugbwrrbugwbwrggrrrrgurgugbuggwbgbgbrwgbuu
rrrwrwgwwggwuuubgguwrurbrwburgwrwbbrgbbwbwuwuuuwbgugwr
bbgrwuwrbuuwwwrugruuuggrrubrwwwbuwwugwburwbrwrwwuwb
uwrgrgwwrgwbgbbwwggrgwrggruuwruurrgwbggwubgrwww
wrggrwurbrruwwurwbgrwguwbgrurgrrgwgurbugrrgbr
bwuwrbguubgrrrbbubbbwbburgwgwbwrggwgugrgguuggrgbuwgb
ugugwwuugwrbwurbwrrruubrwurbrguwwuuguwbrwuurgggbugbbbubrg
gbwwrruruuuwgbwwgbuuuuurwruwgrrgubbrubgwgwwuwgubbwbwgbw
rwbuburrbwgwbubbuuwbrrwgbwrurwbwggrugbbrrrurrbrbg
uurwwubbwbrubgwubrgugwbubgubwruwwrugbwwrugrurgbgwbbu
rwuuuurguruuuuugwbbbbggggggwrbwgwwwruuwrrwgrwburbr
bgruruwwubgugruugugwbburrgwgbggruuubwbwbwburwbrrgbbw
ggrrrwggbgugbuwwgwwubbrurubguwuugbwwbgrwbgubrggruwruuu
ubuwruuwgwburgrgwrubbbubuwgrgburwuwgwurgwb
wgwrggwbuubuwgrgbgrrbubbbbbwrbrwwwwurwrwbuwgwrgbruuwrwrwwrbr
rrugrgwgwgggwbubrgrubgrwbwgbbwwwrrgbuurwwrbrw
uwburbuwgbrrgggggrbbrgwuurrwbbuurbrgrgubwbwwrubrwbbrbrrbr
wggrububrguubwggbrgbrwrrgugggrrrrbgbrgwbugurwruwburbwrb
gwrwugururbwwbrbrrbgrgggrbrbrguwuuugwbugrbu
rbubwrwbrrgrrbgrwubuwrwwwuruwrgwbwrwugubgrrrbr
uwrguugrbgwgrbgrbuwwwrubuwbrgbwrrrwgwwgrbwgwgrbbrgbugrgrw
ubwwrguwurrubwwbrgrwurruwwruggggugrgubrugwrwgg
rurrbrgrrrbwuuburbwrgbwbrwuwbubugbbubgubrrwgbururwwrurbr
wgbwguwwbubrburrbbguguwrrrurwgbgbububgwggrbwguuwrrbwrwruub
gwbrwgggbbgubwurrgguurbugwbwuwurbwuwubuggubrwuug
bbgrbwrwgbgugbgrwrrgguuubuwuurwgwgrubrbubggubgrrwrb
wuubuggggwgbwrurbwggbrbggrgruwwuwbgwbbwbwbrwb
uuwbrwrgrwwruwwgrwrgwrrgrugbwrbgwwwruuggugubru
wuggbgbwwurwbrbbwbubbwwbbwwrrbbgbuwgugburwrwbwwbbgg
bbuggurwrurrugbbgrwrwwbgwbugwrrguubbgwwbubwbbruwru
rgubbrwurbrbrbrrgrubgrwrbruwrurgbuwbwbbbbrbr
wguruwggwurwwwgbubggubuguubgurruurrwbbuugguurbwurru
bbrgrbbwrwbwwwwwgrwwruggrrbgwubbuwggwbrubgrbr
gbguburgwwwgburwbrgwggrugururwggburubuuwbuwwg
ruuwwwgbgguubgrbgwrubruwrbgbbwrrubguuurwru
bbuwbuwwrwuruwbgrururgguurwrwwbwwrrwwwwrugrrwbrbr
urgrubbgrwwuggwgguruwrgwwrbrgbgugbbrwwbbuwbrbr
ugrruwurbugurrbuwrwruguwbubgubuuggguwurrrwrbwguwrrr
gubwwbrrbgwuwuwbuwrrbwggwurgubuugwbgbugurwgrbrgbrbr
wuwbrubwwrbgbbbubbggwburwurgurbwrurwrrrgwugbwgwg
ugrbgububuwuwburwbbuwburbuwbgwrwugwwuwwubguurbguurggu
wbwwrgubrwwwrgwbbbgbguuuubbggbwuruuwwwwrrww
rbrgurrrrwrgruuwwwwubrgubrggrugbuwrgwuurbr
buubwugwwrggrrgrguuwrgwrbbruugburrurbbruuu
bgurgwrwurrubrggubburgwurbwgbwruuwgbwwgwwbwwggrburbuub
wbbgwuggrrggrwrruggrgwubuugbbbguwubgwrwgbwbwrwwgrbgwwguuwb
wurbbggwgbruuwurbbgrrugwuguwuuububrgbuwrwwwrwwgw
rwbwuwrgrwwbgurrruwgwwgrbwbrgwwwwububggbgguwrwbguu
rrwgugbrbggrgwwrwbugrwwuggrurgggubuubruwrgrbr
bgwwuwuuruggbuwgggbgruguguwgbgwguuwwuwuwgrrgruwwbugrbr
rgwggrbuggwrgurguwrrwrgbbuuubbggwgwrwuuwgrwurgruubwgrwgbu
ruwrwbgwbuurwwguruggggrrbbubuwgubgbbggbgrbrrbrwurwrbr
wwgwwrwbwbrguurugggbwbgbruuburbgrbrubrgggbbbruuuugr
urgubbbrggrbburrruubrbrugurggrwbwuuwwurgrbrubr
bguuubrbbgrgwwgurbuuwbwgbruwggbgwgbugrurrgwrrb
rwuggubgrrbugbuugbrrbubwwrrgurrwbbwwuurrbgbwbggggguwggbgb
uwwuguugbwrwwuuuugrrwuuruwurrrbgrgwbuurrurrbbgrrwwrububwr
bbbrwgrwrgbwgrbwwubugrurwuugrwwgwgrwguurgwgurwr
rbgwbgwwwwbwurrrwrwubgggbuguurbrgwururbrbr
gwgugrgbggrgubwwggwwugugbwwwuwubwruuwbbuwwwgb
wbbuwrwgrgbrguuruugrrugwrgubgurwubwwrbrbr
ugbuggugbbbwrbgwwbrbggwrgwugubwbgwwbbbguwrbugbr
gubrruwrwrgwbgwbwwbugbggurwgubgrwububgbbgwuwurbbugwbr
ubgrwwbruuwbbwggugwrguburrrgurugubwrgrwbbgwr
grgrwbbuwwrrgrgwubwwbbugrwrgrwbgbuburrrrbbrbbwrubwgb
uwrurbgrgugwugrgggwrwgwrbwrgbwuguwuwuwgbubwggbwrwbrbr
wwubggrrgbbuwgwrrurbgrbugbwurrruwrbbugguggbwb
urwggrrrrbgbrwbrwbugrrwbrubbbgbgubuuwuugrbwrugbg
wurrubgwbwrwgwggrwbrgwgggburgbuuurrrubrbbb
urbrubwgruwrgrwururwrggbgggrrurgguwwgbruwruubbbwgbwwwbwwbg
buwrbggggwgwuwbrgugrgbuwuuwwrgwuwbbrrrbugrwuuuwguguwgrbr
ubwgrwwwuuruwurbrwwggrwwbubbbwbwbburgbbrbr
ggbuuubbggrrugugbuguuruurbrbburguwwbrurwrwwbrbru
rgwwrbbguwbwrububurwrgurwuwwggbrrrwuuwwugbrrurrgbrgw
wrrugrgbguuburrrrugwugwuggwbwbbuwgwuruguwrrwg
ububbwgubbwgbwrrrubbguruuuwgrwbubbrurwrgwgugur
urrrbuubwwwwggrgbwgwrwbrgguwurbubguwrwuubgruurwur
wrggurrwwugbwgbguwuugwuguwugbrurbbbbwuwwuugwgwwwgrbr
gwwrurwubburbugwwwugbwburubbrwrrwurbruuwwbrgbgwguwwrbr
grubuuuuwbgrugurwburubrurugbbrrggurruwwwurwwubwbrrggrbr
rrbbuugrwuguubrrrbuburrwbggugbwrbuuubruwggruburbrgwbu
wbwgrruwgugbwgrugggbruwbrwrrbbbugrwuwbgwubrwgwwwbugwbrbr
guwruwwrrurruwuubgrgrwwgwugbbbrugwurugbrwwbrb
guuwwrurwwwrrruwbrrrrwgbrbubwrrwuwrwbwbbbwuwwb
gwgrwubguugwwbbgbugbwgurubggbbbgggbgbrrwwrwgwwggg
gbbgrbrbwrgbgrbwrbrbgrwwrwbrrwrrwubwwubwgwrubwwrgbrrbbwuww
bwugbgurrwwrwrbwbwrurbgwrrburgurugwwbwwuubgb
uwbbrbwuuuuburururwrrwbrwrwbwrgruugbuugwrugbbgwbuuwwgugbu
buugurwuuguwwrubgrggwgrwuguwrrgwubwbbwuuuuugrruwbwrgbruuru
rbwwwbwwbggruuuwurubgbgbggbubbwbwgrgbgubbugbubwbrwgrbr
rrrruubrrrwugbuuwguruuburrwgbwgwrbrubrbr
wbrbwwbrrugwbbbubgbbgubrgbugbwgguwrwgrugrguuwggrggruwwrgg
ubrugbrrgbgbrrbbwuwugrgburwrbggruurrgwgbrgbggwbruururg
brubggrugburbbrbrbuuwuurrgbugbbgwbrwubrggrb
rgrrguggbgrbbggbrurruwwgugwururbuurgwuurwbwwugggrbr
grbbuuwubrubgwbwbrbuwubwubuugwuwguwwgbgruug
rbbwbrwggbuubbburuwgrrbbggwwubgguguwgubgwuwrwrguugugbwbbrbr
rubbwbubgbuuwgugbbbwbrgrgrgwrwubwrgwwuururubwrbr
rrbbbbbgrwugubbgwugubgbggrrwbbuuwwbguwubgg
brbwgwbbbbgwbwbgbbbbgwwwuuwrruggwrwburubruugb
rwgwubbuurwrwgwugguguuuwurwrwgruwrgbwbwwbrwwurw
gbuggggruuwggrrwurwggbbugwuuuubgwbgurgbbrbgwbbuwburw
wurwwrguubwwwwuwrgurgugrbrbbbrrwuwwrwwwbrgurbrggrgggurw
uuwwgbuwgruwwrwugurbggwrrurrwwrrrwrwgggubwubgbbr
wuubgwgrugwbbwbwwgrbgurrgurrbgurrurwurbwuwwbg
wugbugwuwubbwbrguguwgwbuuwbwrugbwgrwrbubwwwbwwbrgggg
wrurwububgwrguuwbgugbrbbbuwgububbrgbrbrbbr
rrrwbugwwggwuurbuuwgwugugurrwbbwwbrgrubrwbbggbgwrgbrbu
gubgrbruuguwrwbbrwgwwbbbrgwwbbrgrbbgubwrgrrbburguurrb
wuwbburbrgggwbbrwwgwguburrgburrwuurubgbuburrwrbwwwbwgbub
burubrruruuugwwwbrubrbwwrrubwubgrurruguwwurggbugwguwgrurg
rrggruuuwbrwgbgrrugbuuuwggwrgbrbgbwbuubrrguwwgubguubuuwwub
uuggubguubrwuwbrwwwgubrwrbugurbwgubgrgguugb
ugrbwuurrrgwrrrbrgubbgrburubwgugbwwgruwwbugwwubwuggrwggu
rwbwbuggwuugwggurrurrbwgubbwrwugubugwuwgbgbruwuguwurrguwgw
gbgwbubrbwubugwgwrgbgwwbbgwrruwwwrbuwbbwubrggwrwg
rrbrgwuwgwwwgbrugugruggwrggrrwuggwbguwruwbrggrggwbwb
ubbggwgbrbggurrrwrurugwurbggbgbrwurgrburwb
urwwwbwbgurwgbubrgbwbwwwgrgrrurbbrwbruwrwrurubgwwrgrgb
rwwuurubgggrrggubbwbbwuruwrgbrgubrburgrgwgb
ubrwbubwwgrbbwbrugugurrrwbbuguubururbrbwrwuwbuubg
bubwbwgbwrbuwbwuggwgwwbrwrwggruuurwwwugbrbwur
ruububgrwwubrurwrguwuwubuwbgubggbuwbgwrrwuubwwubgbgwwwu
gubuwbbbwrbguuggbwwgwwgubgrwrgbuwgrgrgrrgrbr
guwbggbuwgbgwuwurwgrbuwggugrururruugwguwug
wwrwruuuwggbrugwrbbgbbugwbubbuggbgwwwwbwuwruwrbggbbw
wrwguwuuugbrbbrwwwbgwubwrgwbrrwuwrwwuwwbrbbgrrurwbbbbw
gbuubwruwrrggwruuwbbburbbbubwugggwgugubgrbubwgwwgbrbr
brbrrugwbruurwwubbgbrwrruwggrggwubgrbrgubgwwggwggruubrgrbr
rrrburwbrbuuwubwubrbwrgubrwgurrurbbgrwggrgwrwrwbwrgbgbrbr
bbwrgrbwwgubgbrububwubuwrwguubwgrgrwuggwbgggrgwwgbubwbu
rbbururbuwgguurubrbgurwwuwugbwbwwrgbrrguuurwggwwgur
grwggrwwgrurrrurgbbgrgwbbubrruwururruubgrgwwgg
bbwwrbwwubgugrwrwgbugwgguwgrwbggruugrwugrrggburbb
wgwwbbuggbrbbgrurwwbwrwrrrwguuugrwggbgbgbbbugrbgrbr
grbwurgbbugubwwbwwwuwrrggwuurubrggguugurgrrurubugrgrugwgw
wrbgggrbuuwbrwrguwggwugwbrgwbwugwguwugbbgrrbr
urrwwwwrrgwwbbggugwgwbgubwguwwwwuwbrgruurwburbrbrbr
wurubwgwbrgrbrgrubbgwuwbuuwwrrgbugrgbwrwuruw
gbwbuubrugbwguggbrubwugugbwrwguruwbguubwuwguurwbrgwgwguw
grwgwwbbbwrgggburgbuugrbruburwwggrwgwgwubgwrubb
ugrubbwbrwububuuugubgrrurrbrwuuuwubrugubbbggrruwggbbg
gurbrgubrubuggburrwgwwuuwrrwbubuwwgrrrwbbgrrrw
burubrgruugrbrgrwgggbgggrbggrurugbbbwrgbgrwwugrbr
uggrbbwwgwwrubbbrbbbwwrrgubwwwrubbgwwggugrwguwrwrrrr
brgwwugwgbugwgwbguwgubuubgwgbgwubguruwrgugwuubwgrrwgww
bgguuugrrrurwwwbugbbruwwrwrwbuuwrbuurrubuwbgrwwuuwgbgbubb
bgwgbrbggwgbwuwgguugwrrrguuwgbrrrbwrubugruuwuuuuwguwbw
wwbuuwwgbguwbrbggbwwuruuuwgubwbuwrwwugrbr
ugwrwgururburbrrgubggbbbgrbrbugurbuggrbrwbub
gbwrrurwgwrgwgrbugwwuwrbguwbbbugbrgwrrrwgguruwrugbr
guurrrwbgguwrwbuguruuwguuwrbubuubwuwbrguubrwwbruububrgubr
wwbwubububbrwbrrbuubbwrgruuwrggwbwwwuggwgrugbb
urwwwwubbbwgbrgurubrwggwuuwubrggrrwuwrrgbrurgg
gwgruwgruruggwgururgbgrubrwwrrubgggrrrrwruwgwrbuubwurrwuw
urwrwwggrurbbubwbuguwrgrwbbwbubwbruwgrbr
bbwubrgguwrubrggruuuruwbbruwuubugrbwubguuuwgbwwuwww
bwwbwgggbguwgrbruuwgggugwbwrwrwrbggrurugugwrrwwugw
uggbugbbuwggwrrugwbwgwgrrgbugurbwuuwwwgruwrwugruw
uggbguuuggrugrubgwgbrurbbwwbrgubbwuguubugubwbubruugbbbgrg
urwubgbwurrwugurbwrrgbrwgrubgggwurrwurugbwuwbbb
rbwugggwurrrwurrbwwguuububbburrgwuwgwbubrrgrgrwbbwwwrbgb
bbuurrwwugbrbgubruburbwwuuuwwuggugrrbrrgrbbubuugbrbrwwggwb
rubuugrrgwrgbbbubrggruggwgwbbrwgrrwurubwururr
uurrbuuwwubwgurgbbrrruwubggrwgggwwbwwrruwggrubgrwugbr
ubggrgwrugbgburrrwbgrwuwurrgwbbuuubgubwrurgrbr
wrbbwwgbggbubugubgbwrurrurgrugwwbbgwbruggb
gbrbbbgbrbrrwwbbuuggbbwguggwbgwrbgubbrbwwguwwuw
gwwwbrgrgrrubrwbbubgrbburuburugrbgguuuwwgrguwbubw
uguwrwubrgbrggrrbwbggbrwurubugguugbubbwrbugbugrr
bgwrbggbubwwgrwrgrwuuruubbruwrwrwgrrubwwuwbuwwubrbgwubrgug
gbgwurbgbgbuwwwubwgrbuubbgggbubrbruwggwugurwgbuu
brbururuugbgrgrgbgrwrbrurbugrwwrggrwgurubggbuw
rwurubwgrugwwgrbgwgbbugrrbgrbrgggurugwwuwbggwbgw
uwbrrrbguurgwwrbrgugwbbwrrrrggugggbbbggrurw
uggurguwwgbbuuwrgwuurrwrwgburguwrwbububurwwbrbuubbrgurrb
ubwguwubggwbrgrguwwuubrgbbgrwwbguwrgrbrwgrbgwwr
rbbrwurrbrgwrrgrurrbwbuuwwubrgbrgurubrrrbrwgwwurwbwurubww
burgbuuwuwwurwgwrrrwuuurggrbgubgrgwbugwwbgrwubuugrbbwuwbu
bbwrbubuugbwrwwbwgrbbwuruuruuwwrwgbuubggbburbbbwubbguwrrgrbr
grbrbgwwgbrrurwwrggrurrwbbbwgwbuwrbrgwbgggwbbwrbr
brrbwugubbrwurruruwwwgguwrrubruubrbwuwugrb
ubwurrrbuurwwbggruguwwbwwgugbgguwrgbuuuwrrbuwgwb
wwgwuwgubrwuwrrbburwrrbgguuggbrrrugrbbbwwwrbgurbwwuwbbwwu
wwubgugrrwbbbuuwwgbrwubbugruuwurgwgrgbrrgrgbrbgrguru
bubrrugwbrrrrbwuurubwburuwwwbgrwubrbwwgrbuuwrgbrbb
bbbuuuururwbbgrbugwbrwgurwgrurguburwrwgbwgw
uwgbugubrggbgugwbuugwgwuruwwrbugruwwbwwwuwwuwrwgbb
rgwbburubruwwurbbrgugrwgbuwrurwrrgruwugguwwbrrrbr
gugrguwuuruubuuuuuwwgubwubuuuubgbwwbguwbwb
bwwwgurbbrwrwbggrwrgbrrbbrgwgrwbgwrrwubuwgw
ubwguuwburubwbwwbwggubbgubbubgrwwrrwubuuwgwwwbwuwggbwuwgbu
gwwggwwgbgwgwrrurugrubbbgbrbbgwgbwwgrwwgwrw
wubwuwgwwubgwrgbwubrgrrwguurbwuwwruurrwbuwbbbbggbwwrgw
ugwrurrbubbwgwrbgrruuwugrgggrgbuwbbruurubrbr
wwrwwrbuwgruuurguruubgwrbuubrwrgwwbubgurwg
rrwuurwrrwrurugwwbwrwbgrwuwwwwruurrwugugrbuu
wggwbwgbrwuurrwwguuuuubgbuwbbbuuwgwwurrwwuwr
ggurbuugbbwbbrbuwrrbrgwubrbuwbbuubwggwuuubrbbrruwr
rgrrwrbwurubrbbruwwwbwgurbwrbuwburwwwrgrbr
buwrrrruwwwrwwguurgurgrggrurugbrwgrubwwuubgrrwrgbgbbrwwrgu
bwwbruwrwrrrwbgbwubgwgrrwgggwwbbwbbrrrwuwuurbbgrbr
ubbwuuurugurbgrgurwgbrwbwguuwwgwwgwrwbuburgrbuwwbgwggub
guurrguwrrgrgwwwubbbrbggwuwrwrrbggbwbbwgubwrwwgwgwrg
wubugbburbbbbwubrwruurrwuwwguuwwbbbbbrwuguu
rgrrrrrrggbbwguwbrbbwuubbwbwugbrwubrrruggrbr
wbbbrgwrbgbuwuwwgrbrbbbugwwurggurgrrugrubbbwuwurbug
uuwgwwwrwbubgbwbgwgbbwrguwrbuwggwgbbwwbugbbrwburruw
rrguwrrwwwrbwuugbuurbuwuwwubruruggrrwwrbbuwrgubgrbr
bwgrwrwubugugwrurrwuguggrwrbbbrrbwgbggubuwbruwbgwwg
wbbuwwwubwwrbwurubgbwurbrwgguwgggrbubbwugrrruguuu
ggrwgrbuubuuugbguwwrgwburrwrbbuggruguwggwrrrw
ubbgbwwwuwbwbuuwruwgbugrrrgbbgwrggwwrruwwrgrbrrru
bruguugrrwrbwrwubbrgrburruggwuruuwwgbbrurugbg
uwgwrugwrbuurrwrrubuugrrgwrwrwgrbgrrwwurggbwwwruwggrruw
ggruuwwugrgwrbrrrruwbwbwuubgrrwwrbwrbgrgrgubwbgguurw
bbwurgburgbrgwbwrwrwuubuuwuwguggbwbbbubwwruggrwuugwwbggu
bgrrbbwgggurgrgggrbwguwbwrgubbgubuguguwwuubgwwwgbbw
gbgwurgwwrgrburugwguwgbwbggubrwuuurbbbrgrrgugwwrbrubgbwb
rrrbrguubgrrgrrrwrbwrbwwrrguwubbrwurrgguurgwgg
ggwrguuuugguwurwgugbbrbgbgbugbwbwrwrrgugrbr
gwubrwugwwbwuugrgugwgbgrbrwuururubwgbwrbwwbrrwwrrrruwgrrww
uruburwuruuwwbgwbrgrugwrbwgggrruwgbbuwgbuwggbrwg
rurugwwggrbbbbwbwwbgbwugugggrurbrgruwgubrwrwwuwurwugwwb
gwrrrgbwrrbbrwbwrrgubgrbrburrrrrwgubrwgwbbburgrrgwgu
uuwrruurbwuwruubugwuwrgwbbuugrbrggbwruuwbrgbwu
gbugbgrrbugrugguugbwwuwggrrggggrwbrgrggrugurugbgwwurw
wbwbgbggrbbugubbwwrubgbgubwuuurbugrurgurwruwuguwrbr
rbbuwrruwwrugrbrwrbwubuguwgrrbwwgbgrggugwwwbwwgwbrur
gwrgggugrurwuugrrggrgrrbrrrgwguwwbwubguwwgbwguwgurbr
bbrbwubgbgrggbbwugbgbwbgrbbwrggbgugwrgwgwuwggbgurbuwrbr
rurrwuurrururrrggbwrbwggbrrbrugwwbubwwuggurwuubwbububbww
bugbwrrbburrbgbwubrrbbuubgguwrwwguwgugbgwgbrggbbwwbuug
wuruguwubgwwrrbrwgbrguuubwgbbwwbwggwrrgrgrb
bbbubbgwgwgbwguggwbggwggbwubugguurbrgbwurgugwugwgubbbubgbrbr
wbuwrbruwurbwwwrwrgrwruurubwrbwggrguwgrrguggbwwugrruggwrr
ruubrbwwuuwburubuugburrwbugrrruwrrggbgrguwrbwbugwgbrbgbrbr
rbwbugbgruwbwwgwguuwuuwwrbrruubwbuwwwubrgurguuurbru
wrrgbugbbrubwwwuwguuuugggbbbwbugbuwwguwbwruurbuwrbr
rwrwuggwrwurgbuuguurgrwrwgwbbbggwwwbgbubbwg
bguguwwgwgguwrurruwwrruruwwrwwbrwwwwgbbbru
wuurbrruwbwbrrurbwrggurrwrgbgwbwubgwwbrubbuwubwbrbu
brrggbrgbwrwgwbrrrrrgwgurbbbgwwrggbwgguwrrrwrw
bbugruwugwbbbgwrwgbgbgbrrbgugwgguuwbgwwwgrggwwguwggrbggu
bggwrwrwwrbwuurrurgugwguggrrwgugubgwuuwwuwgbrgbbbgu
rgubububwrrruwbgubugbbgruuguugbwwwrbbwgrrrrrbwwgggbgrbggu
rbrgrrrrrrrgugwrburbbrbbwwubugggbbbrbbbwwuwbuwbuguwrbr
brwugwbbubrbbgbbugrbrwbrwgbrwrrgugugruuuggurwwbbu
uwrgugwbgrwugbubugrbubwbggbgwubwugurguwwgwggwrrbwrbr
wbwurgbwbrrbburugwbwbbgrrrubrwgguuubrrrubrbr
wwwwrgrgwwgwwubburrgwruwwrurrrrbrbbwbwbuugrbr
rggbrrwgbggrwgruubuuurbwrruwrgwrgggrugruubbuu
"""
