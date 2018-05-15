//
//  SummonLegionBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SummonLegionBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    unowned let transform: Transform
    
    var timer: Float = 0
    
    init(_ transform: Transform) {
        self.transform = transform
    }
    
    func activate() {
        active = true
        let width = Int(4 + 4 * FinalBattle.instance.challenge)
        let rows = Int(2 + 3 * FinalBattle.instance.challenge)
        let side = arc4random() % 2 == 0 ? Map.current.size.x / 4 : Map.current.size.x * 3 / 4
        for i in 0 ..< rows {
            let location = float2(side, -Camera.size.y - 2.m) + float2(0, -0.75.m * Float(i))
            for n in 0 ..< width {
                let spacing = -0.8.m
                let loc = location + float2(spacing * Float(n) - Float(width / 2) * spacing + spacing / 2, 0)
                let soldier = Infrantry(loc)
                Map.current.append(soldier)
            }
        }
    }
    
    func update() {
        timer += Time.delta
        if timer >= 0.5 {
            timer = 0
            active = false
        }
    }
}
