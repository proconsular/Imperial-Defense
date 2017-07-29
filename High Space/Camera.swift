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
    
    static var current: Camera!
    
    var transform = Transform()
    var follow: Transform?
    var clip = true
    var bounds = float2()
    
    init() {
        transform.location = float2(0, -Camera.size.y)
    }
    
    var mask: FixedRect { return FixedRect(transform.location + Camera.size / 2, Camera.size) }
    
    func contains (_ location: float2, _ bounds: float2) -> Bool {
        return
            location.x + bounds.x >= transform.location.x &&
            location.x <= transform.location.x + Camera.size.x &&
            location.y + bounds.y >= transform.location.y &&
            location.y <= transform.location.y + Camera.size.y
    }
    
    func contains (_ rect: FixedRect) -> Bool {
        return FixedRect.intersects(mask, rect)
    }
    
    func update() {
        if let transform = follow {
            let dl = transform.location - transform.location - Camera.size / 2
            transform.location += dl / 4
            if clip {
                moveIntoRegion()
            }
        }
    }
    
    var matrix: GLKMatrix4 {
        return GLKMatrix4MakeTranslation(transform.location.x, transform.location.y, 0)
    }
    
    private func moveIntoRegion () {
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
    
    func distance(_ location: float2) -> Float {
        return (location - transform.location - Camera.size / 2).length
    }
    
    func visible(_ location: float2) -> Bool {
        return distance(location) <= Camera.size.length + 5.m
    }
    
    func visible(_ display: Display) -> Bool {
        return contains(display.transform.location, display.scheme.schemes[0].hull.getBounds().bounds)
    }
    
}
