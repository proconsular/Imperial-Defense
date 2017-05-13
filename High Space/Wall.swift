//
//  Wall.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/10/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Wall: Structure {
    
    var health: Int
    var max: Int
    var sheet: SheetLayout
    
    init(_ location: float2, _ health: Int) {
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
        }
    }
    
    func damage(_ amount: Int) {
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
        }
    }
    
}
