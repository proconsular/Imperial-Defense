//
//  CirclePolygonSolver.swift
//  Raeximu
//
//  Created by Chris Luttio on 9/13/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

//class CirclePolygonSolver: Solver {
//    
//    static func findCollidingFace (polygon: Polygon, _ center: float2, _ radius: Float) -> IndexedValue<Float>? {
//        return findBest(0 ..< polygon.vertices.count, -FLT_MAX, >) {
//            let s = dot(polygon.normals[$0], center - polygon.vertices[$0])
//            if s > radius { return -FLT_MAX }
//            return s
//        }
//    }
//
//    static func solve (primary: Body, _ secondary: Body) -> Collision? {
//        let primary = primary.shape as! Circle, secondary = secondary.shape as! Polygon
//        var solution = Collision()
//        
//        let center = secondary.u.transpose * (primary.location - secondary.location)
//        
//        guard let indexedFaceSeperation = findCollidingFace(secondary, center, primary.radius) else { return nil }
//        
//        let face = secondary.getFace(indexedFaceSeperation.index)
//        
//        if indexedFaceSeperation.value < FLT_EPSILON {
//            (solution.normal, solution.penetration) = (-(secondary.u * secondary.normals[indexedFaceSeperation.index]), primary.radius)
//            solution.contacts = [solution.normal * primary.radius + primary.location]
//            return solution
//        }
//        
//        solution.penetration = primary.radius - indexedFaceSeperation.value
//        
//        for vertex in [face.first, face.second] {
//            if dot(center - vertex, face.vector * (vertex == face.first ? 1 : -1)) <= 0 {
//                if distance_squared(center, vertex) > primary.radius * primary.radius { return nil }
//                (solution.contacts, solution.normal) = ([secondary.transform(vertex)], normalize(secondary.u * (vertex - center)))
//                return solution
//            }
//        }
//        
//        let n = secondary.normals[indexedFaceSeperation.index]
//        if dot(center - face.first, n) > primary.radius { return nil }
//        
//        solution.normal = -(secondary.u * n)
//        solution.contacts = [solution.normal * primary.radius + primary.location]
//        return solution
//    }
//
//    
//}