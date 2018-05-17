//
//  Producer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Producer<Product> {
    var produce: (float2) -> Product
    
    init(_ produce: @escaping (float2) -> Product) {
        self.produce = produce
    }
}
