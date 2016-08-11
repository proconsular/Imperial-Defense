//
//  Region.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Game: DisplayLayer {
    
    let controller: GameController
    
    let player: Player
    
    init() {
        player = Player(float2(Camera.size.x / 2, 0))
        
        controller = GameController()
        controller.append(player)
        controller.append(Structure(float2(Camera.size.x / 2, Camera.size.y), float2(Camera.size.x, 100)))
    }
    
    func use(command: Command) {
        player.use(command)
    }
    
    func update() {
        controller.update()
        Camera.focus(player.transform.location)
    }
    
    func display() {
        controller.render()
    }
}

class GameController {
    let rendermaster: RenderMaster
    let physics: Physics
    
    init() {
        rendermaster = RenderMaster()
        rendermaster.layers.append(RenderLayer())
        physics = Physics()
    }
    
    func append(actor: Actor) {
        physics.bodies.append(actor.body)
        rendermaster.layers.first?.displays.append(actor.display)
    }
    
    func update() {
        physics.update()
    }
    
    func render() {
        rendermaster.render()
    }
}

class Physics {
    var bodies: [Body]
    
    init() {
        Simulation.create()
        bodies = []
    }
    
    func update() {
        Simulation.simulate(&bodies)
    }
}















