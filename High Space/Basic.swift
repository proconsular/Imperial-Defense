//
//  Basic.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/7/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Basic {
    let display: Display
    
    init(_ display: Display) {
        self.display = display
    }
}

class RenderLayer {
    var displays: [Display]
    
    init() {
        displays = []
    }
    
    func render() {
        displays.forEach{ $0.render() }
    }
}

class RenderMaster {
    var layers: [RenderLayer]
    
    init() {
        layers = []
    }
    
    func render() {
        layers.forEach{ $0.render() }
    }
}