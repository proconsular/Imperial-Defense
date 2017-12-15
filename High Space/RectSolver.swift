//
//  RectSolver.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/27/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class RectSolver {
    
    func solve(_ primary: Rect, _ secondary: Rect) -> Collision? {
        let dl = secondary.transform.location - primary.transform.location
        
        let width = primary.bounds.x / 2 + secondary.bounds.x / 2
        let height = primary.bounds.y / 2 + secondary.bounds.y / 2
        
        let x_pen = width - dl.x
        let y_pen = height - dl.y
        
        if x_pen > y_pen {
            return Collision([], float2(0, dl.y > 0 ? 1 : -1), y_pen)
        }else{
            return Collision([], float2(dl.x > 0 ? 1 : -1, 0), x_pen)
        }
    }
    
}
