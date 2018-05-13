//
//  HorizontalMovementController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class HorizontialMovementController: Controller {
    let range: Float = 15.0
    
    var previous = Float.zero, velocity = Float.zero
    var values: (min: Float, max: Float) = (0, 0)
    
    func apply (_ location: float2) -> Command? {
        velocity = location.x - previous
        
        check(&values.min, location, <, min)
        check(&values.max, location, >, max)
        
        guard velocity != 0 else { return nil }
        
        let magnitude = abs(velocity)
        let direction = velocity / magnitude
        
        var command = Command(0)
        command.vector = ((float2(min(magnitude * 10, 500) * direction, 0) * ((1.0 / Float(dt)) / 60)))
        return command
    }
    
    private func check(_ value: inout Float, _ location: float2, _ operation: (Float, Float) -> Bool, _ function: (Float, Float) -> Float) {
        value = function(velocity, value)
        if operation (value, 0) {
            if abs (value - velocity) >= range {
                reset(location)
            }
        }
    }
    
    private func reset(_ location: float2) {
        velocity = 0
        values = (0, 0)
        previous = location.x
    }
}
