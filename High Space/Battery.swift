//
//  Battery.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Battery {
    let limit: Float
    var amount: Float
    
    init(_ limit: Float) {
        self.limit = limit
        amount = 0
    }
    
    var percent: Float {
        return amount / limit
    }
}
