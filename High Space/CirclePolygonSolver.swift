//
//  CirclePolygonSolver.swift
//  Raeximu
//
//  Created by Chris Luttio on 9/13/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class CirclePolygonSolver {
    
    static func solve (primary: Shape<Radialform>, _ secondary: Shape<Edgeform>) -> Collision? {
        var solution = Collision()
        
        let center = secondary.transform.matrix.transpose * (primary.transform.location - secondary.transform.location)
        
        guard let indexed = findCollidingFace(secondary, center, primary.form.radius) else { return nil }
        let (face_normal, separation) = (indexed.index, indexed.value)
        
        let face = secondary.form.getFace(face_normal)
        
        if separation < FLT_EPSILON {
            let poly_normal = secondary.form.normals[face_normal]
            solution.normal = -(secondary.transform.matrix * poly_normal)
            solution.penetration = primary.form.radius
            solution.contacts = [solution.normal * primary.form.radius + primary.transform.location]
            return solution
        }
        
        solution.penetration = primary.form.radius - separation
        
        for vertex in [face.first, face.second] {
            if dot(center - vertex, face.vector * (vertex == face.first ? 1 : -1)) <= 0 {
                if distance_squared(center, vertex) > primary.form.radius * primary.form.radius { return nil }
                solution.contacts = [secondary.getTransformedVertex(vertex)]
                solution.normal = normalize(secondary.transform.matrix * (vertex - center))
                return solution
            }
        }
        
        let n = secondary.form.normals[face_normal]
        if dot(center - face.first, n) > primary.form.radius { return nil }
        
        solution.normal = -(secondary.transform.matrix * n)
        solution.contacts = [solution.normal * primary.form.radius + primary.transform.location]
        return solution
    }
    
    static func findCollidingFace (polygon: Shape<Edgeform>, _ center: float2, _ radius: Float) -> IndexedValue<Float>? {
        return findBest(0 ..< polygon.form.vertices.count, -FLT_MAX, >) {
            let s = dot(polygon.form.normals[$0], center - polygon.form.vertices[$0])
            if s > radius { return -FLT_MAX }
            return s
        }
    }
    
}