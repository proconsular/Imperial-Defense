//
//  CircleSolver.swift
//  Raeximu
//
//  Created by Chris Luttio on 9/13/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

//class CircleSolver: Solver {
//    
//    static func solve (primary: Body, _ secondary: Body) -> Collision? {
//        let primary = primary.shape as! Circle, secondary = secondary.shape as! Circle
//        
//        let n = secondary.location - primary.location
//        let r = primary.radius + secondary.radius
//        
//        if length_squared(n) > r * r { return nil }
//        
//        let d = length(n)
//        
//        if d != 0 {
//            let normal = n / d
//            return Collision([normal * primary.radius + primary.location], normal, r - d)
//        }
//        
//        return Collision([primary.location], float2 (1, 0), primary.radius)
//    }
//    
//    
//}