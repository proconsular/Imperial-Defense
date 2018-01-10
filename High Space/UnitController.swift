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
    
    unowned let soldier: Soldier
    
    let limit: Int
    
    let rate: Float
    var power: Float
    
    var powers: [UnitPower]
    
    var counter: Counter
    
    var turn: Turn!
    
    init(_ soldier: Soldier, _ limit: Int, _ turn_rate: Float, _ rate: Float) {
        self.soldier = soldier
        self.limit = limit
        counter = Counter(turn_rate)
        power = 0
        powers = []
        self.rate = rate
        powers.append(NullPower())
        powers.append(DelayPower(self, 0.25))
        
        turn = UnitTurn(self)
    }
    
    func update() {
        powers.forEach{ $0.update() }
        
        if soldier.transform.location.y <= -Camera.size.y { return }
        
        power += rate * Time.delta
        
        counter.update(Time.delta) {
            turn.process()
        }
    }
    
}

protocol Turn {
    func process()
}

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

protocol PowerSelector {
    func select(_ power: Float, _ open: [UnitPower]) -> UnitPower
}

class MaxSelector: PowerSelector {
    
    func select(_ power: Float, _ open: [UnitPower]) -> UnitPower {
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

class ChaoticSelector: PowerSelector {
    
    func select(_ power: Float, _ open: [UnitPower]) -> UnitPower {
        return open[randomInt(0, open.count)]
    }
    
}

class DelayPower: UnitPower {
    var cost: Float = 0
    
    unowned let controller: UnitController
    
    let amount: Float
    
    init(_ controller: UnitController, _ amount: Float) {
        self.controller = controller
        self.amount = amount
    }
    
    func isAvailable(_ power: Float) -> Bool {
        return true
    }
    
    func invoke() {
        controller.counter.increment = -amount
    }
    
    func update() {
        
    }
    
}

protocol UnitPower {
    var cost: Float { get }
    
    func isAvailable(_ power: Float) -> Bool
    
    func invoke()
    func update()
}

class NullPower: UnitPower {
    var cost: Float = 0
    
    func isAvailable(_ power: Float) -> Bool {
        return true
    }
    
    func invoke() {}
    func update() {}
}













