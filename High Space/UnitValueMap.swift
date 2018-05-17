//
//  LayoutFormer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 9/5/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class UnitValueMap {
    var map: [SoldierValue]
    
    init() {
        map = []
        
        let wave = GameData.info.wave + 1
        
        map.append(SoldierValue(0, 1))
        map.append(SoldierValue(1, 2))
        map.append(SoldierValue(10, 10))
        map.append(SoldierValue(11, 18))
        map.append(SoldierValue(9, 14))
        
        if wave >= 5 {
            var value: Float = 3
            
            if wave >= 21 {
                value = 5
            }
            
            if wave >= 25 {
                value = 7
            }
            
            map.append(SoldierValue(2, value))
        }
        
        if wave >= 12 {
            var value: Float = 4
            
            if wave >= 25 {
                value = 7
            }
            
            if wave >= 30 {
                value = 10
            }
            
            map.append(SoldierValue(3, value))
        }
        
        if wave >= 21 {
            map.append(SoldierValue(4, 4))
            map.append(SoldierValue(8, 4))
        }
        
        if wave >= 30 {
            var value: Float = 6
            
            if wave >= 35 {
                value = 8
            }
            
            if wave >= 40 {
                value = 12
            }
            
            map.append(SoldierValue(5, value))
        }
        
        if wave >= 81 {
            map.append(SoldierValue(6, 25))
        }
        
        if wave >= 85 {
            map.append(SoldierValue(7, 30))
        }
    }
    
    func get(_ id: Int) -> Float {
        for value in map {
            if value.id == id {
                return value.value
            }
        }
        return 0
    }
}

























































