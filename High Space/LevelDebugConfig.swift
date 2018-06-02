//
//  LevelDebugConfig.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/1/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class LevelDebugConfig: GameConfig {
    let wave, shield, barrier: Int
    
    init(_ wave: Int, _ shield: Int, _ barrier: Int) {
        self.wave = wave
        self.shield = shield
        self.barrier = barrier
    }
    
    func configure() {
        LevelDebugConfig.debug(wave, shield, barrier)
        let main = ScreenSpace()
        main.push(PrincipalScreen())
        UserInterface.set(space: main)
    }
    
    static func debug(_ wave: Int, _ shield: Int, _ barrier: Int) {
        GameData.info.wave = wave - 1
        upgrader.shieldpower.range.amount = Float(shield)
        upgrader.barrier.range.amount = Float(barrier)
        GameData.info.points = 0
    }
}
