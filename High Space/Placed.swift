//
//  Placed.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Placed<Element> {
    let element: Element
    var placement: Placement
    
    init(_ placement: Placement, _ element: Element) {
        self.placement = placement
        self.element = element
    }
}
