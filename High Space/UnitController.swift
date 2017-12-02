//
//  UnitController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/30/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class UnitController: Behavior {
    var alive = true
    
    var power: Float
    
    var powers: [UnitPower]
    
    init() {
        power = 0
        powers = []
    }
    
    func update() {
        powers.forEach{ $0.update() }
        
        power += 0.1 * Time.delta
        
        var openPowers = getAvailablePowers(power)
        
        while !openPowers.isEmpty {
            let selected = select(openPowers)
            selected.invoke()
            power -= selected.cost
            
            openPowers = getAvailablePowers(power)
        }
    }
    
    func getAvailablePowers(_ power: Float) -> [UnitPower] {
        return powers.filter{ $0.isAvailable(power) }
    }
    
    func select(_ open: [UnitPower]) -> UnitPower {
        var selected = open.first!
        var dc = power - selected.cost
        
        for p in open {
            let pdc = power - p.cost
            if pdc < dc {
                selected = p
                dc = pdc
            }
        }
        
        return selected
    }
    
}

protocol UnitPower {
    var cost: Float { get }
    
    func isAvailable(_ power: Float) -> Bool
    
    func invoke()
    func update()
}














