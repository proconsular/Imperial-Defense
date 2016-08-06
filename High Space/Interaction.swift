//
//  Interaction.swift
//  Relaci
//
//  Created by Chris Luttio on 9/16/14.
//  Copyright (c) 2014 FishyTale Digital, Inc. All rights reserved.
//

import Foundation
import UIKit

@objc
class Interaction: UIGestureRecognizer {
    
    var down, wasDown: Bool
    var location: float2
    var rawTouch: UITouch?
    
    static var presses: [Interaction] = []
    
    class func appendTouch (touch: Interaction) {
        presses.append(touch)
    }
    
    override init(target: AnyObject?, action: Selector) {
        down = false
        wasDown = false
        location = float2()
        super.init(target: target, action: action)
    }
    
   
    
    private func isSelf (touch: UITouch) -> Bool {
        for press in Interaction.presses where press !== self {
            if let event = press.rawTouch where event === touch {
                return true
            }
        }
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        guard rawTouch == nil else { return }
        for touch in touches where touch.phase == .Began {
            guard !isSelf(touch) else { continue }
            
            update(touch)
            rawTouch = touch
            break
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        if let touch = rawTouch {
            if touch.phase == .Moved {
                update(touch)
                wasDown = true
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        if let touch = rawTouch {
            if touch.phase == .Ended {
                update(touch)
                down = false
                wasDown = true
                rawTouch = nil
            }
        }
    }
    
    private func update (touch: UITouch) {
        let point = touch.locationInView(view)
        let scale = UIScreen.mainScreen().scale
        location = float2(Float(point.x * scale), Float(point.y * scale))
        down = true
    }
    
}


