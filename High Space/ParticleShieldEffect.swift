//
//  ParticleShieldEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

protocol ParticleShieldEffect {
    var alive: Bool { get set }
    var shield: ParticleShield! { get set }
    func use()
    func update()
}
