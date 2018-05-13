//
//  GameLevel.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/26/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GameEvent {
    var complete: Bool { get }
    func activate()
}

protocol GameElement: GameEvent {
    func update()
}

protocol GameLayer: GameElement {
    func use(_ command: Command)
    func render()
}
























