//
//  Upgrades.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/14/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Upgrade {
    var name: String, title: String
    var range: PointRange
    
    init(_ name: String, _ title: String) {
        self.name = name
        self.title = title
        range = PointRange(5)
        range.amount = 0
    }
    
    func upgrade() {
        range.increase(1)
    }
    
    func computeCost() -> Int {
        return Int(4)
    }
}













