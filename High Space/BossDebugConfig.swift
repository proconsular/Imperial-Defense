//
//  BossDebugConfig.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/1/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BossDebugConfig: GameConfig {
    let stage: Int
    
    init(_ stage: Int) {
        self.stage = stage
    }
    
    func configure() {
        LevelDebugConfig.debug(101, 5, 5)
        bossStage = stage
        debugBoss = true
        let main = ScreenSpace()
        main.push(PrincipalScreen())
        UserInterface.set(space: main)
    }
}
