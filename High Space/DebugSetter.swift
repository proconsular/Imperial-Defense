//
//  DebugSetter.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DebugSetter: GameSetter {
    func set(_ game: Game) {
        game.sequence.append(DebugLevel())
    }
}
