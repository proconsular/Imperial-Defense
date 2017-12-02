//
//  EventSetter.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/28/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GameSetter {
    func set(_ game: Game)
}

class LevelSetter: GameSetter {
    func set(_ game: Game) {
        if GameData.info.tutorial {
            game.sequence.append(TutorialLevel(game.interface))
        }
        game.sequence.append(WaveLevel())
        game.sequence.append(WaitElement(2))
        game.sequence.append(VictoryEvent())
        game.layers.append(DebugLayer())
    }
}

class DebugSetter: GameSetter {
    func set(_ game: Game) {
        game.sequence.append(DebugLevel())
    }
}

