//
//  LimitedController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class LimitedController: Controller {
    var controller: Controller
    var rect: FixedRect
    
    init(_ controller: Controller, _ rect: FixedRect) {
        self.controller = controller
        self.rect = rect
    }
    
    func apply(_ location: float2) -> Command? {
        guard rect.contains(location) else { return nil }
        return controller.apply(location)
    }
}
