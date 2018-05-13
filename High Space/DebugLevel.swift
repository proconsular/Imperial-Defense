//
//  DebugLevel.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DebugLevel: GameLayer {
    var buttons: [TextButton]
    var mapper: SoldierMapper
    
    var army = false
    
    init() {
        mapper = SoldierMapper()
        buttons = []
        for i in 0 ..< 7 {
            let button = TextButton(Text("\(i + 2)"), float2(Float(i) * 1.5.m + 4.5.m, -Camera.size.y * 0.875)) { [unowned self] in
                let loc = float2(Camera.size.x / 2 + random(-2.m, 2.m), -Camera.size.y * 0.85)
                Map.current.append(self.mapper[i + 2].produce(loc))
                if self.army {
                    self.generateArmy(loc)
                }
            }
            buttons.append(button)
        }
        
        let loc = float2(Camera.size.x * 0.85, -Camera.size.y * 0.875)
        let text = Text("Army: \(army ? "On" : "Off")", FontStyle(defaultFont, float4(1), 48))
        buttons.append(ToggleTextButton(text, loc) { [unowned self] (active) in
            self.army = active
            text.setString("Army: \(self.army ? "On" : "Off")")
        })
    }
    
    func generateArmy(_ location: float2) {
        let sp_x: Float = 0.75.m
        let sp_y: Float = 1.m
        for x in 0 ..< 3 {
            let sx = Float(x - 1) * sp_x
            for y in 0 ..< 3 {
                if x == 1 && y == 1 { continue }
                let sy = Float(y - 1) * sp_y
                Map.current.append(Infrantry(float2(sx, sy) + location))
            }
        }
    }
    
    var complete: Bool {
        return false
    }
    
    func activate() {
        
    }
    
    func use(_ command: Command) {
        Trigger.process(command) { (command) in
            buttons.forEach{ $0.use(command) }
        }
    }
    
    func update() {
        
        if let player = Player.player {
            if let shield = player.health.shield {
                shield.points.amount = shield.points.limit
            }
        }
        
        removeSoldiers()
    }
    
    func removeSoldiers() {
        for actor in Map.current.actorate.actors {
            if let s = actor as? Soldier {
                if s.body.location.y >= -4.m {
                    s.alive = false
                }
            }
        }
    }
    
    func render() {
        buttons.forEach{ $0.render() }
    }
}
