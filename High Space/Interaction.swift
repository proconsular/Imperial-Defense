//
//  Interaction.swift
//  Relaci
//
//  Created by Chris Luttio on 9/16/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

import Foundation
import UIKit

@objc
class Interaction: UIGestureRecognizer {
    
    var down, wasDown: Bool
    var location: float2
    var rawTouch: UITouch?
    
    static var presses: [Interaction] = []
    
    class func appendTouch (_ touch: Interaction) {
        presses.append(touch)
    }
    
    override init(target: Any?, action: Selector?) {
        down = false
        wasDown = false
        location = float2()
        super.init(target: target, action: action)
    }
    
   
    private func isSelf (_ touch: UITouch) -> Bool {
        for press in Interaction.presses where press !== self {
            if let event = press.rawTouch , event === touch {
                return true
            }
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard rawTouch == nil else { return }
        for touch in touches where touch.phase == .began {
            guard !isSelf(touch) else { continue }
            
            update(touch)
            rawTouch = touch
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = rawTouch {
            if touch.phase == .moved {
                update(touch)
                wasDown = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = rawTouch {
            if touch.phase == .ended {
                update(touch)
                down = false
                wasDown = true
                rawTouch = nil
            }
        }
    }
    
    private func update (_ touch: UITouch) {
        let point = touch.location(in: view)
        let scale = UIScreen.main.scale
        location = float2(Float(point.x * scale), Float(point.y * scale))
        down = true
    }
    
}


