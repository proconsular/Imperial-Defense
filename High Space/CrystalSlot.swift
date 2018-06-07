//
//  CrystalSlot.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class CrystalSlot {
    let slot: Display
    let crystal: Display
    let location: float2
    
    var count: Int
    
    init(_ location: float2, _ count: Int) {
        self.location = location
        self.count = count
        slot = Display(Rect(float2(), float2(40)), GLTexture("Crystal"))
        slot.material["color"] = float4(0, 0, 0, 1)
        slot.color = float4(0, 0, 0, 1)
        slot.material.coordinates = SheetLayout(0, 4, 1).coordinates
        crystal = Display(Rect(float2(), float2(75)), GLTexture("Crystal"))
        crystal.material.coordinates = SheetLayout(0, 4, 1).coordinates
    }
    
    func render() {
        let spacing: Float = 35
        var i: Int = 0
        var n: Int = 0
        while i < count {
            slot.transform.location = location + float2(Float(n) * spacing - Float(count) / 2 * spacing + spacing / 2, 0)
            if i < GameData.info.points {
                slot.color = float4(1)
            }else{
                slot.color = float4(0, 0, 0, 1)
            }
            slot.refresh()
            slot.render()
            i += 1
            n += 1
        }
    }
}
