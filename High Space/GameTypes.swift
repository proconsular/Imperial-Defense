//
//  GameTypes.swift
//  Bot Bounce 2
//
//  Created by Chris Luttio on 3/13/16.
//  Copyright © 2016 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class EventSystem {
    var triggers: [GameTrigger]
    
    init(_ cast: MainCast) {
        triggers = [
            
        ]
    }
    
    func update() {
        triggers.forEach{ $0.evaluate() }
    }
}

class MainCast {
    let principal: Principal
    let info: GameInfo
    
    var events: EventSystem!
    
    init (_ info: GameInfo) {
        self.info = info
        
        principal = Principal(float2(1.5.m, -2.m))
        events = EventSystem(self)
    }
    
    func update() {
        events.update()
    }
}

class World {
    let terrain: Terrain
    var regulator: Regulator!
    
    init(_ cast: MainCast) {
        terrain = Terrain(6)
        regulator = Regulator(GameAssembler(cast, terrain), terrain) { [unowned self] in
            cast.principal.body.location.x + 60.m >= self.regulator.length
        }
    }
    
    func update() {
        regulator.regulate()
        terrain.update()
    }
    
    func render() {
        terrain.render()
    }
}

class GameController {
    let cast: MainCast
    let world: World
    let lighting: Lighting
    let light: Light
    
    init(_ info: GameInfo) {
        cast = MainCast(info)
        world = World(cast)
        world.terrain[0].append(cast.principal)
        lighting = Lighting(world.terrain)
        light = Light(cast.principal.body.location, 1.25, -0.0075, 40000, -0.0025, float4(1, 1, 1, 1))
        lighting.lights.append(light)
        
        Camera.limitView = info.level.hasFloor
        Simulation.create(Double(1.2))
    }
    
    func update() {
        cast.update()
        world.update()
        
        light.location = cast.principal.body.location
        
        var terrain = world.terrain.all
        Simulation.simulate(&terrain)
        Camera.focus(cast.principal.body.location - float2(0.4.m, 0.42.m))
    }
    
    func render() {
        //lighting.render()
        world.render()
    }
}



