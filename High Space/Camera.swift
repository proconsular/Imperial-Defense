//
//  Camera.swift
//  Relaci
//
//  Created by Chris Luttio on 9/16/14.
//  Copyright (c) 2014 FishyTale Digital, Inc. All rights reserved.
//

import UIKit

class Camera {
    
    class var size: float2 {
        let bounds = UIScreen.mainScreen().bounds
        let scaleFactor = UIScreen.mainScreen().scale
        return float2 (Float(bounds.width * scaleFactor), Float(bounds.height * scaleFactor))
    }
    
    static var transform = Transform()
    
    var mask: RawRect { return RawRect(Camera.transform.location, Camera.size) }
    
    static func contains (location: float2, _ bounds: float2) -> Bool {
        return
            location.x + bounds.x >= Camera.transform.location.x &&
            location.x <= Camera.transform.location.x + size.x &&
            location.y + bounds.y >= Camera.transform.location.y &&
            location.y <= Camera.transform.location.y + size.y
    }
    
    static func contains (rect: RawRect) -> Bool {
        return contains(rect.location, rect.bounds)
    }
    
    static func onScreen(body: Physical) -> Bool {
        return Camera.contains(body.getBody().shape.getBounds())
    }

    static func focus(location: float2) {
        let newLocation = location - float2(Camera.size.x / 2, Camera.size.y / 2)
        Camera.transform.location.x = newLocation.x
        Camera.transform.location.y = newLocation.y
        moveIntoRegion()
    }
    
    static func move(delta: float2) {
        transform.location += delta
        //moveIntoRegion()
    }
    
    private static func moveIntoRegion () {
        if transform.location.y + Camera.size.y > 0 {
            transform.location.y += -(transform.location.y + Camera.size.y)
        }
        if transform.location.x < 0 {
            let length = transform.location.x
            transform.location.x += -length
        }
    }
    
    
    static func distance(location: float2) -> Float {
        return (location - Camera.transform.location).length
    }
    
}
