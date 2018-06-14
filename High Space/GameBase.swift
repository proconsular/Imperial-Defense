//
//  GameBase.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class GameBase: GameInterface {
    
    init(_ config: GameConfig) {
        upgrader = Upgrader()
        
        Camera.current = Camera()
        
        UserInterface.create()
        GameData.create()
        AppData.retrieve()
        
        for u in upgrader.upgrades {
            u.range.amount = Float(GameData.info.upgrades[u.name]!)
        }
        
        config.configure()
    }
    
    func update() {
        UserInterface.update()
    }
    
    func render() {
        UserInterface.display()
    }
}
