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













