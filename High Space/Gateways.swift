//
//  Gateways.swift
//  Defender
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
        
        for upgrade in info.upgrades {
            upgrade.range.amount = defaults.float(forKey: upgrade.name)
        }
        
        return info
    }
    
    override func persist(item: GameInfo) {
        let defaults = UserDefaults.standard
        defaults.set(item.level, forKey: "level")
        defaults.set(item.points, forKey: "points")
        defaults.set(item.weapon, forKey: "weapon")
        for upgrade in item.upgrades {
            defaults.set(upgrade.range.amount, forKey: upgrade.name)
        }
    }
    
}
