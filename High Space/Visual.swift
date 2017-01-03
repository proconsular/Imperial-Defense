//
//  Visual.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/29/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Visual {
    let scheme: Scheme
    var display: VisualDisplay!
    
    init(_ scheme: Scheme) {
        self.scheme = scheme
    }
    
    func verify() {
        if display == nil {
            display = GLVisualDisplay(scheme.getRawScheme())
        }
    }
    
    func refresh() {
        verify()
        display.refresh()
    }
    
    func render() {
        verify()
        display.render()
    }
}





















