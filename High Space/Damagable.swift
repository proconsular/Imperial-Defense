//
//  Damagable.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Damagable: class {
    func damage(_ amount: Float)
}

protocol Hittable {
    var reaction: HitReaction? { get }
}
