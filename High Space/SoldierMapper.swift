//
//  SoldierMapper.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SoldierMapper {
    
    var map: [Int: Producer<Soldier>]
    
    init() {
        map = [:]
        
        map.updateValue(Producer(Scout.init), forKey: 0)
        map.updateValue(Producer(PusherScout.init), forKey: 10)
        
        map.updateValue(Producer(Infrantry.init), forKey: 1)
        map.updateValue(Producer(ArmoredInfrantry.init), forKey: 8)
        map.updateValue(Producer(HardInfrantry.init), forKey: 9)
        
        map.updateValue(Producer(Charger.init), forKey: 11)
        
        map.updateValue(Producer(Captain.init), forKey: 2)
        map.updateValue(Producer(Heavy.init), forKey: 3)
        
        map.updateValue(Producer(Thief.init), forKey: 4)
        map.updateValue(Producer(Warrior.init), forKey: 5)
        
        map.updateValue(Producer(Titan.init), forKey: 6)
        map.updateValue(Producer(Phantom.init), forKey: 7)
        
    }
    
    subscript(_ value: Int) -> Producer<Soldier> {
        get { return map[value]! }
    }
    
}
