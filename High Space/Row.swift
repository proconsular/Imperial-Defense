//
//  Row.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Row: Battalion {
    var soldiers: [Soldier]
    var amount: Int
    
    init(_ soldiers: [Soldier]) {
        self.soldiers = soldiers
        amount = soldiers.count
    }
    
    func update() {
        soldiers = soldiers.filter{ $0.alive }
    }
    
    var health: Int {
        return soldiers.count
    }
}
