//
//  DataTypes.swift
//  Comm
//
//  Created by Chris Luttio on 9/1/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

struct Substance {
    
    var material: Material
    var mass: Mass
    var friction: Friction
    
    init(_ material: Material, _ mass: Mass, _ friction: Friction) {
        self.material = material
        self.mass = mass
        self.friction = friction
    }
    
    static var Solid: Substance {
        return Substance(Material(.static), Mass.Immovable, Friction(.ice))
    }
    
    static func getStandard(_ mass: Float) -> Substance {
        return Substance(Material(.static), Mass.fixed(mass), Friction(.ice))
    }
    
    static func StandardRotating(_ mass: Float, _ inverse_interia: Float) -> Substance {
        return Substance(Material(.static), Mass(mass, 1 / inverse_interia), Friction(.ice))
    }
    
}

struct Friction {
    
    enum `Type` {
        case rubber, iron, ice
    }
    
    var still, inmotion: Float
    
    init (_ type: Type) {
        switch type {
        case .rubber:
            still = 1.1
            inmotion = 0.9
        case .iron:
            still = 0.5
            inmotion = 0.4
        case .ice:
            still = 0.2
            inmotion = 0.1
        }
    }
    
    init (_ statik: Float, _ dynamic: Float) {
        self.still = statik
        self.inmotion = dynamic
    }
    
}

struct Mass {
    var mass, inv_mass: Float
    var inertia, inv_inertia: Float
    
    init (_ mass: Float, _ inertia: Float) {
        self.mass = mass
        self.inv_mass = mass != 0 ? 1 / mass : 0
        self.inertia = inertia
        self.inv_inertia = inertia != 0 ? 1 / inertia : 0
    }
    
    static var Immovable: Mass {
        return self.init(0, 0)
    }
    
    static func fixed (_ mass: Float) -> Mass {
        return self.init(mass, 1E+20)
    }
    
    static func pivot (_ inertia: Float) -> Mass {
        return self.init(0, inertia)
    }
}

struct Material {
    
    enum `Type` {
        case rock, wood, `static`, bouncyBall, superBall
    }
    
    var density, restitution: Float
    
    init (_ type: Type){
        var ntype = type
        if funmode {
            ntype = .superBall
        }
        switch ntype {
        case .rock:
            density = 0.6
            restitution = 0.1
        case .wood:
            density = 0.3
            restitution = 0.2
        case .static:
            density = 0
            restitution = 0.2
        case .bouncyBall:
            density = 0.3
            restitution = 0.8
        case .superBall:
            density = 0.3
            restitution = 0.95
        }
    }
    
    init (density: Float, restitution: Float){
        self.density = density
        self.restitution = restitution
    }
}

struct Face {
    let first, second, vector, normal, center: float2
    
    init (_ first: float2, _ second: float2) {
        self.first = first
        self.second = second
        vector = second - first
        normal = -normalize(float2(vector.y, -vector.x))
        center = (first + second) / 2
    }
}

struct Collision {
    
    var penetration: Float
    var normal: float2
    var contacts: [float2]
    
    init(_ contacts: [float2], _ normal: float2, _ penetration: Float) {
        self.contacts = contacts
        self.normal = normal
        self.penetration = penetration
    }
    
    init() {
        self.init([], float2(), 0)
    }
    
    var valid: Bool {
        return !contacts.isEmpty
    }
    
    var count: Float {
        return Float(contacts.count)
    }
    
}

class Pair<T> {
    var primary, secondary: T
    
    init(_ primary: T, _ secondary: T) {
        self.primary = primary
        self.secondary = secondary
    }
}

func == (prime: BodyPair, secunde: BodyPair) -> Bool {
    let equal = prime.primary === secunde.primary && prime.secondary === secunde.secondary
    let cross = prime.primary === secunde.secondary && prime.secondary === secunde.primary
    return equal || cross
}

class BodyPair: Pair<Body>, Equatable {
    
    var rebound: Float = 0
    var still: Float = 0
    var inmotion: Float = 0
    
    override init(_ primary: Body, _ secondary: Body) {
        rebound = 1 + min(primary.substance.material.restitution, secondary.substance.material.restitution)
        still = length(primary.substance.friction.still)
        inmotion = length(primary.substance.friction.inmotion)
        super.init(primary, secondary)
    }
    
    func getRelativeVelocity (_ contact: float2) -> float2 {
        return -primary.getRelativeVelocity(contact) + secondary.getRelativeVelocity(contact)
    }
    
    func getInverseMass (_ contact: float2, _ normal: float2) -> Float {
        return primary.getInverseMass(contact, normal) + secondary.getInverseMass(contact, normal)
    }
    
    func getInverseMass () -> Float {
        return primary.substance.mass.inv_mass + secondary.substance.mass.inv_mass
    }
    
    var hasInfiniteMass: Bool {
        return equal(primary.substance.mass.inv_mass + secondary.substance.mass.inv_mass, 0)
    }
    
    func applyImpulse (_ contact: float2, _ impulse: float2) {
        primary.applyImpulse(-impulse, contact)
        secondary.applyImpulse(impulse, contact)
    }
    
    func clear() {
        primary.velocity = float2()
        secondary.velocity = float2()
    }
    
    func correct(_ correction: float2) {
        primary.correct(-correction)
        secondary.correct(correction)
    }
    
    func callback(_ collision: Collision) {
        primary.callback(secondary, collision)
        secondary.callback(primary, collision)
    }
    
}

func == (prime: Manifold, secunde: Manifold) -> Bool {
    return prime.pair == secunde.pair
}
