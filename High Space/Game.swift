//
//  Region.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

let clear = false

let kScale = Camera.size / float2(1136, 640)

class Game: DisplayLayer {
    let principal: Principal
    let world: World
    
    init() {
        principal = Principal(float2(2.m, -2.m))
        world = World(principal)
        world.terrain[0].append(principal)
        Simulation.create(Double(1.2))
    }
    
    func use(command: Command) {
        principal.use(command)
    }
    
    func update() {
        world.update()
        var terrain = world.terrain.all
        Simulation.simulate(&terrain)
        Camera.focus(principal.body.location - float2(0.4.m, 0.42.m))
    }
    
    func display() {
        world.render()
    }
}

















