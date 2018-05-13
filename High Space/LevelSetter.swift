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
        game.sequence.append(WaveLevel())
        game.sequence.append(WaitElement(2))
        game.sequence.append(VictoryEvent())
        
        if debugDisplay {
            game.layers.append(DebugLayer())
        }
        
        if GameData.info.wave + 1 >= 101 {
            game.layers.append(FinalBattleLayer())
        }
    }
}
