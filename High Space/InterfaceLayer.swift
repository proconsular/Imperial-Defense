//
//  InterfaceLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class InterfaceLayer: DisplayLayer {
    
    var location = float2()
    var objects: [InterfaceElement] = []
    var active = true
    
    func update() {
        
    }
    
    func display() {
        guard active else { return }
        objects.forEach{$0.render()}
    }
    
    func use(_ command: Command) {
        guard active else { return }
        objects.map{$0 as? Interface}.forEach{$0?.use(command)}
    }
    
}

protocol InterfaceElement {
    var location: float2 { get set }
    func render()
}


