//
//  WarriorController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class WarriorController: UnitController {
    
    init(_ soldier: Soldier) {
        super.init(soldier, 1, 0.1, 0.25)
        
        power = 1
        
        let wave = GameData.info.wave + 1
        
        let roam = FreeRoamPower(soldier, 1, 0.5, 3)
        roam.conditions.append(LineOfSightCondition(soldier))
        
        let spray = FireSprayPower(soldier, 1, 1)
        spray.conditions.append(LineOfSightCondition(soldier))
        
        let reflect = ReflectPower(soldier, 1, 4)
        reflect.conditions.append(ThreatenedCondition(soldier.transform))
        
        if wave < 65 {
            powers.append(roam)
        }
        
        if wave >= 35 {
            powers.append(spray)
        }
        
        if wave >= 40 {
            powers.append(reflect)
        }
        
        if wave >= 65 {
            let shortroam = FreeRoamPower(soldier, 0.5, 0.25, 1.5)
            shortroam.conditions.append(LineOfSightCondition(soldier))
            let longroam = FreeRoamPower(soldier, 2, 1.5, 3)
            longroam.conditions.append(LineOfSightCondition(soldier))
            
            let roamcomplex = ComplexPower()
            roamcomplex.append(0, shortroam)
            roamcomplex.append(1, roam)
            roamcomplex.append(2, longroam)
            roamcomplex.set(1)
            
            powers.append(roamcomplex)
        }
    }
    
}
