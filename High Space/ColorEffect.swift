//
//  ColorEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

protocol ColorEffect {
    func affect(_ color: float4) -> float4
    func update()
}
