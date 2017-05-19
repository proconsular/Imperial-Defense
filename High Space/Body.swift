//
//  Body.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/29/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
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
    var mask: Int = 1
    var noncolliding = false
    
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
        relativeGravity = 0
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
    
    func canCollide(_ other: Body) -> Bool {
        guard mask & other.mask > 0 else { return false }
        return collide(other)
    }
    
    func collide(_ other: Body) -> Bool {
        return FixedRect.intersects(shape.getBounds(), other.shape.getBounds())
    }
    
}
