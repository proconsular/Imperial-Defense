//
//  EnergyWavePower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class EnergyWavePower: TimedUnitPower {
    
    unowned let transform: Transform
    var waves: [EnergyWave]
    
    init(_ transform: Transform, _ cost: Float, _ wait: Float) {
        self.transform = transform
        waves = []
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        
        var angle = atan2f(1, random(-0.25, 0.25))
        
        if let player = Player.player {
            let dl = player.transform.location - transform.location
            angle = atan2f(dl.y, dl.x)
        }
        
        for i in 0 ..< 2 {
            waves.append(EnergyWave(transform.location, Float(i) * 0.005.m + 0.05.m, angle))
        }
        
        Audio.play("wave-blast", 0.5)
    }
    
    override func update() {
        super.update()
        waves = waves.filter{ $0.alive }
        waves.forEach{ $0.update() }
    }
    
}

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
















