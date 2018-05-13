//
//  Physics.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/30/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

let multiplier: Double = 1
let framesPerSecond: Double = 150

let dt: Double = 1.0 / (framesPerSecond * multiplier)
let gravity = float2(0, 2000)

class Simulation {
    
    private let iterations = 1
    
    var speedLimit = 1.0
    var speed = 1.0
    
    var processor = Processor(0.2)
    
    let grid: Grid
    
    init(_ grid: Grid, speed: Double = 1) {
        self.grid = grid
        speedLimit = speed
        self.speed = speedLimit
    }
    
    func halt() {
        speed = 0
    }
    
    func unhalt() {
        speed = speedLimit
    }
    
    func simulate() {
        let bodies = grid.actorate.actors.map{ $0.body }
        processor.process(dt, step(bodies, dt * speed))
    }
    
    private func step(_ bodies: [Body], _ dt: Double) {
        let delta = Float(dt)
        
        bodies.forEach{ $0.applyForces(delta) }
        bodies.forEach{
            $0.applyVelocity(delta)
            $0.clearForces()
        }
    }
    
}
