//
//  GameControllerLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class GameControllerLayer: ControllerLayer {
    override init() {
        super.init()
        let movement = LimitedController(HorizontialMovementController(), FixedRect(float2(Camera.size.x / 4, Camera.size.y / 2), float2(Camera.size.x / 2, Camera.size.y)))
        
        let jump = LimitedController(PointController(1), FixedRect(float2(Camera.size.x * 3 / 4, Camera.size.y / 2), float2(Camera.size.x / 2, Camera.size.y)))
        
        let interface = LimitedController(PointController(4), FixedRect(float2(Camera.size.x / 2, Camera.size.y * 0.25 / 2), float2(Camera.size.x, Camera.size.y * 0.25)))
        
        self.subcontrollers = [interface, movement, jump]
    }
}
