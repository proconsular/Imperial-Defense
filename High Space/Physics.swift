//
//  Physics.swift
//  Comm
//
//  Created by Chris Luttio on 8/30/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation
import simd
import Accelerate

let multiplier: Double = 1
let framesPerSecond: Double = 60

let dt: Double = 1.0 / (framesPerSecond * multiplier)
let gravity = float2(0, 12.m)

class Simulation {
    
    private let iterations = 3
    
    var speedLimit = 1.0
    private var speed = 1.0
    
    var processor = Processor(0.2)
    var broadphaser: Broadphaser
    
    let grid: Grid
    
    init(_ grid: Grid, speed: Double = 1) {
        self.grid = grid
        speedLimit = speed
        self.speed = speedLimit
        broadphaser = Broadphaser(grid)
    }
    
    func halt() {
        speed = 0
    }
    
    func unhalt() {
        speed = speedLimit
    }
    
    func simulate() {
        let bodies = grid.actors.map{ $0.body }
        processor.process(dt, step(bodies, dt * speed))
    }
    
    private func step(bodies: [Body], _ dt: Double) {
        let delta = Float(dt)
        let contacts = broadphaser.getContacts()
        
        bodies.forEach{ $0.applyForces(delta) }
        contacts.forEach{ $0.process(delta, iterations) }
        bodies.forEach{
            $0.applyVelocity(delta)
            $0.clearForces()
        }
        contacts.forEach{ $0.applyCorrection() }
    }
    
}