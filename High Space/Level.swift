//
//  Level.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/26/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Level {
    let enforcer: BehaviorRuleEnforcer
    let simulation: Simulation
    let scenery: Scenery
    let map: Map
    
    init() {
        map = Map(float2(20.m, 40.m))
        simulation = Simulation(map.grid)
        GameCreator.createWalls(Map.current, 0.15.m)
        scenery = Scenery(GameCreator.createBarriers())
        BehaviorQueue.instance = BehaviorQueue()
        enforcer = BehaviorRuleEnforcer()
    }
    
    func update() {
        map.update()
        simulation.simulate()
        enforcer.update()
        scenery.update()
    }
    
    func render() {
        scenery.render()
    }
}
