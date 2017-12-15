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
    
    init(_ transform: Transform, _ cost: Float, _ wait: Float) {
        self.transform = transform
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
            createWave(Float(i) * 0.005.m + 0.05.m, angle)
        }
    }
    
    func createWave(_ distance: Float, _ start: Float) {
        let range = 15.toRadians
        let step = 1.toRadians / 4
        
        let count = Int(range / step)
        
        for i in 0 ..< count {
            let angle = start + -range / 2 + step * Float(i)
            let normal = float2(cosf(angle), sinf(angle))
            let red = FireEnergy(distance * 20 * normal + transform.location, random(10, 14))
            red.transform.location -= distance * 19 * float2(cosf(start), sinf(start))
            red.color = float4(1, 0.5, 0.5, 1)
            red.rate = 0.5
            red.body.velocity += normal * 8.m
//            red.drag = float2(0.995)
            Map.current.append(red)
        }
    }
    
}
