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
    
    static var location: float2 = float2()
    static var limitView = true
    
    var mask: RawRect { return RawRect(Camera.location, Camera.size) }
    
    static func contains (location: float2, _ bounds: float2) -> Bool {
        return
            location.x + bounds.x >= Camera.location.x &&
            location.x <= Camera.location.x + size.x &&
            location.y + bounds.y >= Camera.location.y &&
            location.y <= Camera.location.y + size.y
    }
    
    static func contains (rect: RawRect) -> Bool {
        return contains(rect.location, rect.bounds)
    }
    
    static func containsPiece (piece: Piece) -> Bool {
        let location = float2(Piece.getLength(piece.index) - (Piece.width) / 2, 0)
        let bounds = float2(Piece.width * 2, 0)
        return
            location.x + bounds.x >= Camera.location.x &&
            location.x <= Camera.location.x + size.x
    }
    
    static func onScreen(body: Physical) -> Bool {
        return Camera.contains(body.getBody().shape.getBounds())
    }

    static func focus(location: float2) {
        let newLocation = location - float2 (Camera.size.x / 2, Camera.size.y / 2) + float2 (150 / 2, 150 / 2)
        let dl = newLocation - Camera.location
        Camera.location.x = newLocation.x
        Camera.location.y += dl.y / 6
        limitView.isTrue(moveIntoRegion())
    }
    
    private static func moveIntoRegion () {
        if location.y + Camera.size.y > 0 {
            location.y += -(location.y + Camera.size.y)
        }
        if location.x < 0 {
            let length = location.x
            location.x += -length
        }
    }
    
    
    static func distance(location: float2) -> Float {
        return (location - Camera.location).length
    }
    
}
