//
//  DataTypes.swift
//  Comm
//
//  Created by Chris Luttio on 9/1/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

typealias Callback = (Body, Collision) -> ()

class Body {
    
    var shape: Hull
    
    var substance: Substance
    
    var velocity: float2 = float2()
    var angular_velocity: Float = 0
    
    var force: float2 = float2 ()
    var torque: Float = 0
    
    var callback: Callback
    
    var tag: String?
    var relativeGravity: Float = 1
    var timeStamp: Int = 0
    var hidden = false
    var mask: Int = 1
    
    var object: AnyObject?
    
    var location: float2 {
        set { shape.transform.location = newValue }
        get { return shape.transform.location }
    }
    
    var orientation: Float {
        set { shape.transform.orientation = newValue }
        get { return shape.transform.orientation }
    }
    
    init (_ shape: Hull, _ substance: Substance, callback: @escaping Callback = { _ in }) {
        self.shape = shape
        self.substance = substance
        self.callback = callback
    }
    
    func applyImpulse (_ impulse: float2, _ contact: float2) {
        velocity += substance.mass.inv_mass * impulse
        angular_velocity += substance.mass.inv_inertia * cross(contact - location, impulse).z
    }
    
    func applyVelocity(_ dt: Float) {
        if substance.mass.inv_mass == 0 { return }
        location += velocity * dt
        orientation += angular_velocity * dt
        applyForces(dt)
    }
    
    func applyForces(_ dt: Float) {
        if substance.mass.inv_mass == 0 { return }
        velocity += (force * substance.mass.inv_mass + gravity * relativeGravity) * (dt / 2)
        angular_velocity += torque * substance.mass.inv_inertia * (dt / 2)
    }
    
    func clearForces() {
        force = float2 ()
        torque = 0
    }
    
    func addForce(_ force: float2) {
        self.force += force
    }
    
    func addVelocity(_ velocity: float2) {
        self.velocity += velocity
    }
    
    func getRelativeVelocity(_ contact: float2) -> float2 {
         return velocity + crossff2(angular_velocity, contact - location)
    }
    
    func getInverseMass(_ contact: float2, _ normal: float2) -> Float {
        return substance.mass.inv_mass + sqr(cross(contact - location, normal).z) * substance.mass.inv_inertia
    }
    
    func correct(_ correction: float2) {
        location += substance.mass.inv_mass * correction
    }
    
}

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
    
    fileprivate func getRelativeVelocity (_ contact: float2) -> float2 {
        return -primary.getRelativeVelocity(contact) + secondary.getRelativeVelocity(contact)
    }
    
    fileprivate func getInverseMass (_ contact: float2, _ normal: float2) -> Float {
        return primary.getInverseMass(contact, normal) + secondary.getInverseMass(contact, normal)
    }
    
    fileprivate func getInverseMass () -> Float {
        return primary.substance.mass.inv_mass + secondary.substance.mass.inv_mass
    }
    
    fileprivate var hasInfiniteMass: Bool {
        return equal(primary.substance.mass.inv_mass + secondary.substance.mass.inv_mass, 0)
    }
    
    fileprivate func applyImpulse (_ contact: float2, _ impulse: float2) {
        primary.applyImpulse(-impulse, contact)
        secondary.applyImpulse(impulse, contact)
    }
    
    fileprivate func clear() {
        primary.velocity = float2()
        secondary.velocity = float2()
    }
    
    fileprivate func correct(_ correction: float2) {
        primary.correct(-correction)
        secondary.correct(correction)
    }
    
    fileprivate func callback(_ collision: Collision) {
        primary.callback(secondary, collision)
        secondary.callback(primary, collision)
    }
    
}

func == (prime: Manifold, secunde: Manifold) -> Bool {
    return prime.pair == secunde.pair
}

class Manifold: Equatable {
    typealias Solve = (Body, Body) -> Collision?
    
    let percent: Float = 0.4, slop: Float = 0.05
    
    var pair: BodyPair
    var collision: Collision
    
    init (_ pair: BodyPair){
        self.pair = pair
        collision = Collision()
    }
    
    func solve() {
        var solution: Collision?
        if let prime = pair.primary.shape as? Shape<Edgeform>, let secunde = pair.secondary.shape as? Shape<Edgeform> {
            solution = PolygonSolver.solve(prime, secunde)
        }
        if let prime = pair.primary.shape as? Shape<Radialform>, let secunde = pair.secondary.shape as? Shape<Radialform> {
            solution = CircleSolver.solve(prime, secunde)
        }
        if let prime = pair.primary.shape as? Shape<Radialform>, let secunde = pair.secondary.shape as? Shape<Edgeform> {
            solution = CirclePolygonSolver.solve(prime, secunde)
        }
        if let prime = pair.primary.shape as? Shape<Edgeform>, let secunde = pair.secondary.shape as? Shape<Radialform> {
            solution = CirclePolygonSolver.solve(secunde, prime)
            if let sol = solution {
                solution!.normal = -sol.normal
            }
        }
        
        guard let col = solution else { return }
        
        collision = col
        pair.callback(collision)
    }
    
    func verify() -> Bool {
        return collision.valid
    }
    
    func process() {
        guard !pair.hasInfiniteMass else { pair.clear(); return }
        
        for contact in collision.contacts {
            let relative_velocity = pair.getRelativeVelocity(contact)
            let relative_length = dot(relative_velocity, collision.normal)
            
            if relative_length > 0 { return }
            
            let relative_normal = relative_length * collision.normal
            let tangent = normalize_safe(relative_velocity - relative_normal) ?? float2()
            
            let inversemass = 1.0 / (pair.getInverseMass(contact, collision.normal) * collision.count)
            
            let linearimpulse = -pair.rebound * inversemass * relative_normal
            let totalimpulse = linearimpulse + tangent * getFriction(-dot(relative_velocity, tangent) * inversemass, length(linearimpulse))
            
            pair.applyImpulse(contact, totalimpulse)
        }
    }
    
    fileprivate func getFriction(_ tangentforce: Float, _ impulse: Float) -> Float {
        guard abs(tangentforce) >= impulse * pair.still else { return tangentforce }
        return -impulse * pair.inmotion
    }
    
    func process (_ processedTime: Float, _ iterations: Int) {//
        iterations.cycle(process)
    }
    
    func applyCorrection() {
        let scalar = max(collision.penetration - slop, 0) / pair.getInverseMass() * percent
        pair.correct(scalar * collision.normal)
    }
    
}