//
//  StatusItem.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

protocol StatusItem {
    var percent: Float { get }
    var color: float4 { get }
    func update()
}
