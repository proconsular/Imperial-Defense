//
//  Placement.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

struct Placement {
    var location: int2
    
    init(_ location: int2) {
        self.location = location
    }
    
    func computeIndex(_ width: Int) -> Int {
        return Int(location.x) + Int(location.y) * width
    }
}
