//
//  Being.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation
import simd

class Being: Physical {
    var body: Body!
    
    var onObject: Bool = false
    var wasOnObject = false
    
    var visual: Visual!
    
    init () {
        
    }
    
    init (_ location: float2, _ bounds: float2, _ texture: GLuint) {
        body = Body(Rect(Transform(location), bounds), Substance(Material(.Static), Mass(0.1, 100), Friction(.Iron)))
        visual = Visual(VisualScheme(Rect(Transform(location), bounds), VisualInfo(getTexture("white"))))
    }
    
    func getBody() -> Body {
        return body
    }
    
    func update (processedTime: Float) {
        
    }
    
    func display () {
        Being.display(visual, body.location, body.orientation)
    }
    
//    static func interpolate (body: Body) -> (float2, Float) {
//        let remainder = Simulation.processor.getRemainder()
//        let inverse_remainder = 1 - remainder
//        let location = body.getLastShape().location * Float(remainder) + body.location * Float(inverse_remainder)
//        let orientation = body.getLastShape().orientation * Float(remainder) + body.orientation * Float(inverse_remainder)
//        return (location, orientation)
//    }
//    
    static func display (visual: Visual, _ location: float2, _ orientation: Float, _ offset: float2 = float2()) {
        let sch = visual.scheme as! VisualScheme
        sch.hull.transform.location = location - Camera.location + offset
        sch.hull.transform.orientation = orientation
        visual.render()
    }
    
}