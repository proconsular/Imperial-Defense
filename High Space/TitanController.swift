//
//  TitanController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class TitanController: UnitController {
    
    let powersource: Battery
    
    init(_ soldier: Soldier) {
        powersource = Battery(100)
        
        super.init(soldier, 1, 0.1, 0.25)
        
        power = 1
        
        let counterdefend = CounterDefendBehavior(soldier, powersource)
        
        soldier.behavior.base.append(counterdefend)
        
        powers.append(StealEnergyPower(soldier, powersource, 2.m, 2, 0.75, 2.5))
        powers.append(StealEnergyPower(soldier, powersource, 4.m, 0.5, 1, 3))
        
        let wave = EnergyWavePower(soldier.transform, 0.5, 1.5)
        wave.conditions.append(BatteryChargedCondition(powersource, 50))
        
        powers.append(wave)
        
        let quake = QuakePower(soldier, 0.5, 1.5)
        quake.conditions.append(BatteryChargedCondition(powersource, 25))
        
        powers.append(quake)
    }
    
}






















