//
//  Time.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

@objc class Time: NSObject {
    static var delta: Float = 0
    static var scale: Float = 1
    static var normal: Float = 0
    
    @objc static func set(_ time: Float) {
        self.delta = time * scale
        self.normal = time
    }
}
