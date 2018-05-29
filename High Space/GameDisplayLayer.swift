//
//  GameDisplayLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/26/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GameDisplayLayer {
    func update()
    func render()
}

class DebugLayer: GameDisplayLayer {
    let grade: Text
    
    init() {
        let location = float2(Camera.size.x * 0.1, -Camera.size.y * 0.875)
        grade = Text(location, "Grade: X", FontStyle(defaultFont, float4(1), 48))
    }
    
    func update() {
        
    }
    
    func render() {
        grade.render()
    }
    
}

class FinalBattleLayer: GameDisplayLayer {
    let battle: FinalBattle
    
    init() {
        battle = FinalBattle()
    }
    
    func update() {
        if let player = Player.player {
            if !player.alive {
                Game.showFailScreen()
            }
        }
    }
    
    func render() {
        if let emperor = Emperor.instance {
            emperor.render()
        }
    }
}
