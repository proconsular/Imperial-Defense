//
//  PowerSelector.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

protocol PowerSelector {
    func select(_ power: Float, _ open: [UnitPower]) -> UnitPower
}
