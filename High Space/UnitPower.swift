//
//  UnitPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

protocol UnitPower {
    var cost: Float { get }
    
    func isAvailable(_ power: Float) -> Bool
    
    func invoke()
    func update()
}
