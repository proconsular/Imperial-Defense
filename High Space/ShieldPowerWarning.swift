//
//  ShieldPowerWarning.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

protocol PowerWarning {
    func update(_ percent: Float)
    func apply(_ color: float4) -> float4
}
