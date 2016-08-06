//
//  Object.swift
//  Comm
//
//  Created by Chris Luttio on 9/1/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Object: Physical {
    
    var body: Body
    var visual: Visual
    
    init (body: Body, texture: GLuint) {
        self.body = body
        switch body.shape {
        //case let x as Circle:
            //self.visual = Image (atPosition: x.location.GLKVector(), radius: x.radius, withTexture: texture)
        case let x as Polygon:
            visual = Visual(VisualScheme(Polygon(Transform(x.transform.location), x.form.vertices), VisualInfo(texture)))
        default:
            visual = Visual(VisualScheme(Polygon(Transform(), []), VisualInfo(texture)))
        }
    }
    
    static func box (location: float2, _ bounds: float2, _ texture: GLuint) -> Object {
        return Object(body: Body.box(location, bounds, Substance.Solid), texture: texture)
    }
    
    func getBody() -> Body {
        return body
    }
    
    func update(processedTime: Float) {
        
    }
    
    func display() {
        Being.display(visual, body.location, body.orientation)
    }
    
}