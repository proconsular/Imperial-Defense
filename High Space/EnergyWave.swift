//
//  EnergyWave.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class EnergyWave {
    let location: float2
    let range = 15.toRadians
    let step = 1.toRadians / 4
    var count: Int
    
    var alive = true
    
    weak var transform: Transform?
    
    var hum: Counter
    
    init(_ location: float2, _ distance: Float, _ start: Float) {
        self.location = location
        count = Int(range / step)
        hum = Counter(0.2)
        create(distance, start)
    }
    
    func create(_ distance: Float, _ start: Float) {
        for i in 0 ..< count {
            let angle = start + -range / 2 + step * Float(i)
            let normal = float2(cosf(angle), sinf(angle))
            let red = FireEnergy(distance * 20 * normal + location, random(10, 14))
            red.transform.location -= distance * 19 * float2(cosf(start), sinf(start))
            red.color = float4(1, 0.5, 0.5, 1)
            red.rate = 0.5
            red.body.velocity += normal * 8.m
            Map.current.append(red)
            if i == count / 2 {
                transform = red.transform
            }
        }
    }
    
    func update() {
        alive = transform != nil
        
        hum.update(Time.delta) {
            Audio.play("wave-move", 0.25)
        }
    }
}
