//
//  Wall.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/10/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Wall: Structure, Damagable {
    var reflective: Bool = false
    
    var health: Float
    var max: Float
    var sheet: SheetLayout
    
    init(_ location: float2, _ health: Float) {
        self.health = health
        max = health
        let amount = upgrader.barrier.range.amount
        sheet = SheetLayout(3 - Int(amount / 1.5), 1, 6)
        super.init(location, float2(64, 32) * 4)
        material["texture"] = GLTexture("barrier_castle").id
        material["color"] = float4(1, 1, 1, 1)
        material.coordinates = sheet.coordinates
        body.object = self
        body.mask = 0b1
        material["order"] = -1
    }
    
    override func update() {
        if health <= 0 {
            let destroy = Audio("barrier-destroyed")
            destroy.volume = 1
            destroy.start()
            alive = false
            let count = Int(random(5, 10))
            for _ in 0 ..< count {
                makeParts()
            }
        }
    }
    
    func damage(_ amount: Float) {
        health -= amount
        play("barrier-hit")
        
        let percent = Float(health) / Float(max)
        
        let index = sheet.index
        
        let l = floorf(upgrader.barrier.range.amount / 1.5)
        let level = l + 3
        let step = 1 / level
        
        for n in 0 ..< Int(level) {
            if percent >= 1 - step * Float(n + 1) && percent <= 1 - step * Float(n) {
                sheet.index = n + 3 - Int(l)
                break
            }
        }
        material.coordinates = sheet.coordinates
        
        if index != sheet.index {
            play("barrier-breakdown")
            let count = Int(random(5, 10))
            for _ in 0 ..< count {
                makeParts()
            }
        }
        
        let count = Int(random(5, 10))
        for _ in 0 ..< count {
            makeParts()
        }
    }
    
    func makeParts() {
        let width: Float = 64 * 4
        let height: Float = 32 * 4
        let spark = Particle(transform.location + float2(random(-width / 2, width / 2), random(-height / 2, 0)), random(4, 9))
        let col = random(0.5, 0.75)
        spark.color = float4(col, col, col, 1)
        let velo: Float = 400
        spark.body.relativeGravity = 1
        spark.rate = 2.5
        spark.body.velocity = float2(random(-velo, velo) / 2, random(-velo, -velo / 2))
        Map.current.append(spark)
    }
    
}
