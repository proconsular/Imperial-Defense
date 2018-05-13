//
//  GameBase.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class GameBase: GameInterface {
    
    init() {
        upgrader = Upgrader()
        
        Camera.current = Camera()
        
        UserInterface.create()
        GameData.create()
        
        for u in upgrader.upgrades {
            u.range.amount = Float(GameData.info.upgrades[u.name]!)
        }
        
        let main = ScreenSpace()
        main.push(Splash())
        UserInterface.set(space: main)
    }
    
    func update() {
        UserInterface.update()
    }
    
    func render() {
        UserInterface.display()
    }
    
    static func debug(wave: Int, gun: Int, shield: Int, barrier: Int) {
        GameData.info.wave = wave - 1
        
        upgrader.firepower.range.amount = Float(gun)
        upgrader.shieldpower.range.amount = Float(shield)
        upgrader.barrier.range.amount = Float(barrier)
        GameData.info.points = 0
    }
}
