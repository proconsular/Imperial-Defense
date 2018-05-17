//
//  DisplayGroupRenderer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DisplayGroupRenderer: GraphicsRenderer {
    var renderers: [Display]
    
    init() {
        renderers = []
    }
    
    func append(_ info: GraphicsInfo) {
        renderers.append(Display(info.hull, info.material as! ClassicMaterial))
    }
    
    func compile() {
        
    }
    
    func update() {
        
    }
    
    func render() {
        for renderer in renderers {
            renderer.refresh()
            renderer.render()
        }
    }
}
