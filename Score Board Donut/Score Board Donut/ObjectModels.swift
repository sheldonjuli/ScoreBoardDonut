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

class Board {
    var players = [Player]()
    
    init(playerNum : Int) {
        for _ in 1...playerNum {
            let player = Player()
            players += [player]
        }
    }
}
