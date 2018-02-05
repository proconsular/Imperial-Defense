//
//  GameplayController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/5/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GameplayController {
    static var current = GameplayController()
    
    var powerlimit: Float
    var slots: [UnitPower]
    
    let rate: Float
    var counter: Float = 0
    
    init() {
        rate = 10
        powerlimit = 1.5
        
        let wave = GameData.info.wave + 1
        
        if wave >= 50 {
            powerlimit = 2
        }
        
        slots = []
    }
    
    func update() {
        counter += Time.delta
        if counter >= rate {
            counter = 0
            slots.removeAll()
        }
    }
    
    func place(_ power: UnitPower) {
        slots.append(power)
    }
    
    func isPlacable(_ power: UnitPower) -> Bool {
        return computeTotalPower() + power.cost <= powerlimit
    }
    
    func isOpen() -> Bool {
        return computeTotalPower() < powerlimit
    }
    
    func computeTotalPower() -> Float {
        var sum: Float = 0
        for slot in slots {
            sum += slot.cost
        }
        return sum
    }
}
