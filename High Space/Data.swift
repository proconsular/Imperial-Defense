//
//  Data.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GameData {
    static var info = GameInfo.Default
    
    private static var gateway: Gateway<GameInfo> = GameDefaultsGateway()
    
    static func create() {
        if let loadedInfo = gateway.retrieve(name: "default") {
            info = loadedInfo
        }
    }
    
    static func persist() {
        gateway.persist(item: info)
    }
    
    static func reset() {
        info = GameInfo.Default
        upgrader = Upgrader()
        persist()
    }
    
}

struct GameInfo {
    var name: String
    var level: Int
    var points: Int
    var weapon: Int
    var bank: Int
    var wave: Int
    var upgrades: [String: Int]
    var story: Story
    
    init() {
        name = "default"
        level = 0
        points = 0
        weapon = 0
        bank = 0
        wave = 0
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



