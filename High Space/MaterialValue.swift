//
//  MaterialValue.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

struct MaterialValue: Equatable {
    var name: String
    var value: Any
    var sorted: Bool = true
    
    init(_ name: String, _ value: Any) {
        self.name = name
        self.value = value
    }
}
