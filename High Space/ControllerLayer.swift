//
//  ControllerLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ControllerLayer: Controller {
    var subcontrollers: [Controller]
    
    init () {
        subcontrollers = []
    }
    
    func apply (_ location: float2) -> Command? {
        for controller in subcontrollers {
            if let command = controller.apply(location) {
                return command
            }
        }
        return nil
    }
}
