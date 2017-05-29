//
//  Wall.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/10/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Wall: Structure, Damagable {
    
    var health: Float
    var max: Float
    var sheet: SheetLayout
    
    init(_ location: float2, _ health: Float) {
        self.health = health
        max = health
        sheet = SheetLayout(0, 1, 3)
        super.init(location, float2(64, 32) * 4)
        display.texture = GLTexture("barrier_castle").id
        display.color = float4(1, 1, 1, 1)
        display.coordinates = sheet.coordinates
        body.object = self
        body.mask = 0b1
        display.order = -1
    }
    
    override func update() {
        if health <= 0 {
            play("barrier_destroy")
            alive = false
            let count = Int(random(5, 10))
            for _ in 0 ..< count {
                makeParts()
            }
        }
    }
    
    func damage(_ amount: Float) {
        health -= amount
        play("barrier_hit")
        
        let percent = Float(health) / Float(max)
        
        let index = sheet.index
        
        if percent >= 0.33 && percent <= 0.66 {
            sheet.index = 1
            display.coordinates = sheet.coordinates
        }
        
        if percent <= 0.33 {
            sheet.index = 2
            display.coordinates = sheet.coordinates
        }
        
        if index != sheet.index {
            play("barrier_ruin")
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
