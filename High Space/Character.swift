//
//  Character.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

extension Float {
    var normalized: Float? {
        guard self != 0 else { return nil }
        return self / abs(self)
    }
}

class Character: Being {
    
    var director: Director?
    var direction: Float = 1
    
    var animations: [TextureAnimation] = []
    var currentAnimation: TextureAnimation?
    
    init(_ location: float2, _ bounds: float2) {
        super.init(location, bounds, 0)
    }
    
    override func update(processedTime: Float) {
        director?.update(processedTime)
        direction = computeDirection()
        animate(processedTime)
        
        wasOnObject = onObject
        onObject = false
    }
    
    func computeDirection() -> Float {
        guard let newDirection = body.velocity.x.normalized else { return direction }
        return -newDirection
    }
    
    func animate (processedTime: Float) {}
    
    func setAnimation (animation: TextureAnimation) {
        let scheme = visual.scheme as! VisualScheme
        scheme.info.texture = animation.reader.getTexture()
        scheme.layout.coordinates = animation.reader.getCoordinates()
        visual.refresh()
    }
    
}