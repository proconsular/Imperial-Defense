//
//  Command.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

struct Command {
    var vector: float2?
    let id: Int
    
    init(_ id: Int) {
        self.id = id
    }
}
