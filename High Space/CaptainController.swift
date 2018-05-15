//
//  CaptainController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class CaptainController: UnitController {
    
    init(_ soldier: Soldier) {
        super.init(soldier, 1, 0.1, 0.25)
        
        power = 1
        
        let wave = GameData.info.wave + 1
        
        let charge = ChargePower(soldier.transform, 3.m, 1.5, 1, 1)
        charge.conditions.append(PlayerAwayCondition(soldier.transform, 2.5.m))
        
        let protect = GuardPower(soldier, 0.5, 6)
        protect.conditions.append(ThreatenedCondition(soldier.transform))
        
        let fire = FireCallPower(soldier.transform, 3.m, 5, 1, 2)
        fire.conditions.append(LineOfSightCondition(soldier))
        
        if wave <= 50 {
            powers.append(charge)
        }
        
        if wave >= 21 {
            powers.append(protect)
        }
        
        if wave >= 25 && wave < 55  {
            powers.append(fire)
        }
        
        if wave >= 51 {
            let longcharge = ChargePower(soldier.transform, 3.m, 2.5, 2, 1)
            longcharge.conditions.append(PlayerAwayCondition(soldier.transform, 2.5.m))
            let shortcharge = ChargePower(soldier.transform, 4.m, 0.5, 0.75, 2)
            
            let chargecomplex = ComplexPower()
            chargecomplex.append(0, shortcharge)
            chargecomplex.append(1, charge)
            chargecomplex.append(2, longcharge)
            chargecomplex.set(1)
            
            powers.append(chargecomplex)
        }
        
        if wave >= 55 {
            let shortfire = FireCallPower(soldier.transform, 5.m, 2, 0.75, 1.5)
            shortfire.conditions.append(LineOfSightCondition(soldier))
            let longfire = FireCallPower(soldier.transform, 2.m, 15, 2, 2)
            longfire.conditions.append(LineOfSightCondition(soldier))
            
            let firecomplex = ComplexPower()
            firecomplex.append(0, shortfire)
            firecomplex.append(1, fire)
            firecomplex.append(2, longfire)
            firecomplex.set(1)
            
            powers.append(firecomplex)
        }
        
    }
    
}



























