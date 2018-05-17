//
//  SingleRendererMethod.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SingleRendererMethod: GraphicsMethod {
    var renderers: [BaseRenderer]
    
    init() {
        renderers = []
    }
    
    func create(_ info: GraphicsInfo) {
        let renderer = BaseRenderer()
        renderer.append(info)
        renderer.compile()
        renderers.append(renderer)
    }
    
    func update() {
        for renderer in renderers {
            renderer.clean()
        }
        renderers = renderers.filter{ !$0.graphics.isEmpty }
        renderers = renderers.sorted{ ($0.graphics[0].material["order"] as! Int) < ($1.graphics[0].material["order"] as! Int) }
        renderers.forEach{ $0.update() }
    }
    
    func clear() {
        renderers.removeAll()
    }
    
    func render() {
        for renderer in renderers {
            let bounds = renderer.graphics[0].hull.getBounds()
            if Camera.current.contains(bounds) {
                renderer.render()
            }
        }
    }
}
