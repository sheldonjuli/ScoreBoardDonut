//
//  ObjectModels.swift
//  Score Board Donut
//
//  Created by Li Ju on 2018-08-12.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import Foundation

struct Player {
    var id : Int
    var score : Int
    
    private static var currId = 0
    
    static func restartPlayerCount() {
        currId = 0
    }
    
    private static func getUniqueId() -> Int {
        currId += 1
        return currId
    }
    
    init() {
        self.id = Player.getUniqueId()
        self.score = 0
    }
}

class Game {
    var players = [Player]()
    
    init(numPlayer : Int) {
        for _ in 1...numPlayer {
            let player = Player()
            players += [player]
        }
    }
}

class Stopwatch: NSObject {
    var counter: Double
    var timer: Timer
    
    override init() {
        counter = 0.0
        timer = Timer()
    }
}
