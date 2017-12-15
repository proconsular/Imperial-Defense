//
//  HeavyController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/23/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class HeavyController: UnitController {
    
    init(_ soldier: Soldier) {
        super.init(soldier, 1, 0.1, 0.25)
        
        power = 1
        
        let wave = GameData.info.wave + 1
        
        let fire = RapidFirePower(soldier, 1, 1, 2)
        fire.conditions.append(LineOfSightCondition(soldier))
        
        let missile = MissilePower(soldier, 0.5, 4)
        missile.conditions.append(LineOfSightCondition(soldier))
        
        let lockdown = LockdownPower(soldier, 0.25, 0.25, 4)
        lockdown.conditions.append(ThreatenedCondition(soldier.transform))
        
        if wave < 60 {
            powers.append(fire)
        }
        
        if wave >= 25 {
            powers.append(missile)
        }
        
        if wave >= 30 {
            powers.append(lockdown)
        }
        
        if wave >= 60 {
            let shortfire = RapidFirePower(soldier, 0.5, 0.5, 1)
            shortfire.conditions.append(LineOfSightCondition(soldier))
            let longfire = RapidFirePower(soldier, 2, 2, 2)
            longfire.conditions.append(LineOfSightCondition(soldier))
            
            let firecomplex = ComplexPower()
            firecomplex.append(0, shortfire)
            firecomplex.append(1, fire)
            firecomplex.append(2, longfire)
            
            powers.append(firecomplex)
        }
    }
    
}
