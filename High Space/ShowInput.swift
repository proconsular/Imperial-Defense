//
//  ShowInput.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/19/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ShowInput {
    let transform: Transform
    let base, radius: Display
    
    init(_ location: float2, _ size: Float) {
        transform = Transform(location)
        base = Display(Rect(transform, float2(size)), GLTexture("ShowInput-Base"))
        radius = Display(Rect(transform, float2(size)), GLTexture("ShowInput-Case"))
    }
    
    var color: float4 {
        get {
            return base.color
        }
        set {
            base.color = newValue
            radius.color = newValue
        }
    }
    
    func render() {
        radius.refresh()
        radius.render()
        
        base.refresh()
        base.render()
    }
}
