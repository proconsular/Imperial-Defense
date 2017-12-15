//
//  PhantomController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/29/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PhantomController: UnitController {
    
    let battery: Battery
    let pool: BlastPool
    
    init(_ soldier: Soldier) {
        battery = Battery(150)
        battery.amount = 100
        pool = BlastPool()
        
        super.init(soldier, 1, 0.1, 0.25)
        
        soldier.behavior.base.append(PhaseBehavior(soldier, battery))
        
        powers.append(ConsumePower(soldier, battery, 0, 1))
        
        let blast = EnergyBlastPower(soldier, battery, pool, 0.5, 3)
        blast.conditions.append(BatteryChargedCondition(battery, 100))
        
        powers.append(blast)
        
        powers.append(GravitateUnitsPower(soldier, 0.25, 2))
        
        powers.append(RadiatePower(soldier, 0.5, 2))
    }
    
    override func update() {
        super.update()
        
        pool.update()
    }
    
}
