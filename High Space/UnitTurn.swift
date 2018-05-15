//
//  UnitTurn.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class UnitTurn: Turn {
    unowned let controller: UnitController
    let selector: PowerSelector
    
    init(_ controller: UnitController) {
        self.controller = controller
        selector = ChaoticSelector()
    }
    
    func process() {
        for power in controller.powers {
            if let complex = power as? ComplexPower {
                complex.set(randomInt(0, complex.powers.count))
            }
        }
        
        var openPowers = getAvailablePowers(controller.power)
        
        var count = 0
        
        while !openPowers.isEmpty && count < controller.limit {
            let selected = selector.select(controller.power, openPowers)
            if !GameplayController.current.isPlacable(selected) {
                break
            }
            selected.invoke()
            GameplayController.current.place(selected)
            controller.power -= selected.cost
            
            openPowers = getAvailablePowers(controller.power)
            
            count += 1
        }
    }
    
    func getAvailablePowers(_ power: Float) -> [UnitPower] {
        return controller.powers.filter{ $0.isAvailable(power) }
    }
}
