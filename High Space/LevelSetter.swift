//
//  LevelSetter.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class LevelSetter: GameSetter {
    func set(_ game: Game) {
        if GameData.info.tutorial {
            game.sequence.append(TutorialLevel(game.interface))
        }
        var timeout: Float = 2
        if GameData.info.wave + 1 >= 101 {
            timeout = 6
        }
        game.sequence.append(WaveLevel())
        game.sequence.append(WaitElement(timeout))
        game.sequence.append(VictoryEvent())
        
        if debugDisplay {
            game.layers.append(DebugLayer())
        }
        
        if GameData.info.wave + 1 >= 101 {
            game.layers.append(FinalBattleLayer())
        }
    }
}
