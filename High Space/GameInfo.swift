//
//  GameInfo.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

struct GameInfo {
    var name: String
    var level: Int
    var points: Int
    var weapon: Int
    var bank: Int
    var wave: Int
    var upgrades: [String: Int]
    var story: Story
    var challenge: Int
    var tutorial: Bool
    
    init() {
        name = "default"
        level = 0
        points = 0
        weapon = 0
        bank = 0
        wave = 0
        challenge = 0
        tutorial = true
        upgrades = ["Gun": 0, "Shield": 0, "Barrier": 0]
        story = StoryGateway().retrieve(name: "story")
    }
    
    mutating func progress() {
        level += 1
    }
    
    static var Default: GameInfo {
        return GameInfo()
    }
    
    mutating func record(_ upgrader: Upgrader) {
        for u in upgrader.upgrades {
            upgrades[u.name] = Int(u.range.amount)
        }
    }
}
