//
//  CircleSolver.swift
//  Raeximu
//
//  Created by Chris Luttio on 9/13/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class CircleSolver {
    
    static func solve <T> (_ primary: Shape<T>, _ secondary: Shape<T>) -> Collision? where T: Radialform {
        let n = secondary.transform.location - primary.transform.location
        let r = primary.form.radius + secondary.form.radius
        
        if length_squared(n) > r * r { return nil }
        
        let d = length(n)
        
        if d != 0 {
            let normal = n / d
            return Collision([normal * primary.form.radius + primary.transform.location], normal, r - d)
        }
        
        return Collision([primary.transform.location], float2 (1, 0), primary.form.radius)
    }
    
    
}
