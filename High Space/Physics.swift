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

let multiplier: Double = 2
let framesPerSecond: Double = 60

let dt: Double = 1.0 / (framesPerSecond * multiplier)
let gravity = float2(0, 12.m)

class Simulation {
    
    private static let iterations = 3
    
    static var speedLimit = 1.0
    private static var speed = 1.0
    
    static var processor = Processor(0.2)
    
    private static var broadphaser = Broadphaser()
    
    static func create(speed: Double = 1) {
        speedLimit = speed
        self.speed = speedLimit
    }
   
    static func halt() {
        speed = 0
    }
    
    static func unhalt() {
        speed = speedLimit
    }
    
    static func simulate (inout bodies: [Body]) {
        broadphaser.prepare(&bodies)
        processor.process(dt, step(&bodies, dt * speed))
    }
    
    private static func step (inout bodies: [Body], _ dt: Double) {
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