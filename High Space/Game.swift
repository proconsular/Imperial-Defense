//
//  Region.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Game: DisplayLayer {
    
    let rendermaster: RenderMaster
    let basic: Basic
    
    init() {
        Simulation.create()
        
        rendermaster = RenderMaster()
        let layer = RenderLayer()
        let rect = Rect(float2(100), float2(100))
        rect.transform.assign(Camera.transform)
        let dis = Display(rect, GLTexture("white"))
        basic = Basic(dis)
        layer.displays.append(dis)
        rendermaster.layers.append(layer)
    }
    
    func use(command: Command) {
        if case .Vector(let force) = command {
            Camera.move(force / 1000)
            print(Camera.transform.location)
            let sc = basic.display.visual.scheme as! VisualScheme
            print(sc.hull.transform.global.location)
        }
    }
    
    func update() {
        
    }
    
    func display() {
        rendermaster.render()
    }
}

















