//
//  Manifold.swift
//  Defender
//
//  Created by Chris Luttio on 10/29/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Manifold: Equatable {
    
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
    
    private func getFriction(_ tangentforce: Float, _ impulse: Float) -> Float {
        guard abs(tangentforce) >= impulse * pair.still else { return tangentforce }
        return -impulse * pair.inmotion
    }
    
    func process (_ processedTime: Float, _ iterations: Int) {
        for _ in 0 ..< iterations {
            process()
        }
    }
    
    func applyCorrection() {
        let scalar = max(collision.penetration - slop, 0) / pair.getInverseMass() * percent
        pair.correct(scalar * collision.normal)
    }
    
}
