//
//  Gateways.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Gateway<T> {
    
    func retrieve(name: String) -> T? {
        return nil
    }
    
    func persist(item: T) {
        
    }
    
}

class GameDefaultsGateway: Gateway<GameInfo> {
    
    override func retrieve(name: String) -> GameInfo? {
        var info = GameInfo.Default
        
        let defaults = UserDefaults.standard
        
        info.level = defaults.integer(forKey: "level")
        info.points = defaults.integer(forKey: "points")
        info.weapon = defaults.integer(forKey: "weapon")
        info.wave = defaults.integer(forKey: "wave")
        info.challenge = defaults.integer(forKey: "challenge")
        info.tutorial = defaults.bool(forKey: "tutorial")
        info.reviewed = defaults.bool(forKey: "reviewed")
        for u in info.upgrades.keys {
            info.upgrades.updateValue(defaults.integer(forKey: u), forKey: u)
        }
        
        return info
    }
    
    override func persist(item: GameInfo) {
        let defaults = UserDefaults.standard
        defaults.set(item.level, forKey: "level")
        defaults.set(item.points, forKey: "points")
        defaults.set(item.weapon, forKey: "weapon")
        defaults.set(item.wave, forKey: "wave")
        defaults.set(item.challenge, forKey: "challenge")
        defaults.set(item.tutorial, forKey: "tutorial")
        defaults.set(item.reviewed, forKey: "reviewed")
        defaults.setValuesForKeys(item.upgrades)
    }
    
}
