import Foundation

/*
 42
 19
 11
 57
 500346

 42515755
 11.137023541
 */

func puzzle6() {
    let races = [
        Race(time: 50, distance: 222),
        Race(time: 92, distance: 2031),
        Race(time: 68, distance: 1126),
        Race(time: 90, distance: 1225)
    ]
    races.forEach({ print($0.numberOfPossibleWins())})
    print(races.reduce(1) { $0 * $1.numberOfPossibleWins()})

    let race = Race(time: 51926890, distance: 222203111261225)
    print(race.numberOfPossibleWins())
}

struct Race {
    let time: Int
    let distance: Int

    func numberOfPossibleWins() -> Int {
        (1...self.time).reduce(0) {
            (self.time - $1) * $1 > self.distance ? $0 + 1 : $0
        }
    }
}


/*        var possibilities = 0, start = false
        for i in 1...self.time {
            if (self.time - i) * i > self.distance {
                possibilities+=1
                if(!start) {
                    print(i)
                }
                start = true
            } else {
                if start { return possibilities }
            }
        }
        return possibilities */
