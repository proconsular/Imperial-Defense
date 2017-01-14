//
//  Camera.swift
//  Relaci
//
//  Created by Chris Luttio on 9/16/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

import UIKit

class Camera {
    
    class var size: float2 {
        let bounds = UIScreen.main.bounds
        let scaleFactor = UIScreen.main.scale
        return float2 (Float(bounds.width * scaleFactor), Float(bounds.height * scaleFactor))
    }
    
    static var transform = Transform()
    static var follow: Transform?
    static var clip = true
    static var bounds = float2()
    
    static func create(_ map: Map) {
        transform.location = float2(map.size.x / 2 - Camera.size.x / 2, -Camera.size.y)
    }
    
    static var mask: FixedRect { return FixedRect(Camera.transform.location + Camera.size / 2, Camera.size) }
    
    static func contains (_ location: float2, _ bounds: float2) -> Bool {
        return
            location.x + bounds.x >= Camera.transform.location.x &&
            location.x <= Camera.transform.location.x + size.x &&
            location.y + bounds.y >= Camera.transform.location.y &&
            location.y <= Camera.transform.location.y + size.y
    }
    
    static func contains (_ rect: FixedRect) -> Bool {
        return FixedRect.intersects(Camera.mask, rect)
    }
    
    static func update() {
        if let transform = follow {
            let dl = transform.location - Camera.transform.location - Camera.size / 2
            Camera.transform.location += dl / 4
            if Camera.clip {
                moveIntoRegion()
            }
        }
    }
    
    static var matrix: GLKMatrix4 {
        return GLKMatrix4MakeTranslation(transform.location.x, transform.location.y, 0)
    }
    
    private static func moveIntoRegion () {
        if transform.location.y + Camera.size.y > 0 {
            transform.location.y += -(transform.location.y + Camera.size.y)
        }
        if transform.location.y < -bounds.y {
            transform.location.y += (-bounds.y - transform.location.y)
        }
        if transform.location.x < 0 {
            transform.location.x += -transform.location.x
        }
        if transform.location.x + Camera.size.x > bounds.x {
            transform.location.x +=  bounds.x - (transform.location.x + Camera.size.x)
        }
    }
    
    static func distance(_ location: float2) -> Float {
        return (location - Camera.transform.location - Camera.size / 2).length
    }
    
    static func visible(_ location: float2) -> Bool {
        return Camera.distance(location) <= Camera.size.length + 5.m
    }
    
}
