//
//  Data.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Data {
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
    
}

struct GameInfo {
    var name: String
    var level: Int
    var points: Int
    var weapon: Int
    var bank: Int
    var wave: Int
    
    var upgrades: [Upgrade]
    
    init() {
        name = "default"
        level = 0
        points = 0
        weapon = 0
        bank = 0
        wave = 0
        upgrades = []
    }
    
    mutating func progress() {
        level += 1
    }
    
    static var Default: GameInfo {
        var info = GameInfo()
        info.upgrades.append(contentsOf: [SniperBulletUpgrade(), MachineGunUpgrade(), BombGunUpgrade(), HealthUpgrade(), BarrierUpgrade(), MovementUpgrade()])
        return info
    }
    
    var sniper: SniperBulletUpgrade {
        return upgrades[0] as! SniperBulletUpgrade
    }
    
    var machine: MachineGunUpgrade {
        return upgrades[1] as! MachineGunUpgrade
    }
    
    var bomb: BombGunUpgrade {
        return upgrades[2] as! BombGunUpgrade
    }
    
    var health: HealthUpgrade {
        return upgrades[3] as! HealthUpgrade
    }
    
    var barrier: BarrierUpgrade {
        return upgrades[4] as! BarrierUpgrade
    }
    
    var movement: MovementUpgrade {
        return upgrades[5] as! MovementUpgrade
    }
}



