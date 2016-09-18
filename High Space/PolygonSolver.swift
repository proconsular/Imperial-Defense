//
//  PolygonSolver.swift
//  Raeximu
//
//  Created by Chris Luttio on 9/13/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class PolygonSolver {
    
    static func solve <T> (_ primary: Shape<T>, _ secondary: Shape<T>) -> Collision? where T: Edgeform {
        guard let (collidingFaces, normal) = findCollidingFaces(primary, secondary) else { return nil }
        
        let referenceFace = collidingFaces.reference.getTransformedFace(collidingFaces.index)
        guard let clippedIncidentFace = clipIncidentFace(referenceFace, findIncidentFace(collidingFaces)) else { return nil }
        
        let solution = resolve(referenceFace, clippedIncidentFace)
        return Collision(solution.contacts, referenceFace.normal * normal, solution.penetration)
    }
    
    static fileprivate func findCollidingFaces <T> (_ primary: Shape<T>, _ secondary: Shape<T>) -> ((reference: Shape<T>, incident: Shape<T>, index: Int), Float)? where T: Edgeform {
        guard let primaryAxis = findLeastPenetratingAxis(primary, secondary), let secondaryAxis = findLeastPenetratingAxis(secondary, primary) else { return nil }
        let greatestAxis = BiasGreaterThan(primaryAxis.value, secondaryAxis.value)
        return ((reference: greatestAxis ? primary : secondary, incident: greatestAxis ? secondary : primary, index: greatestAxis ? primaryAxis.index : secondaryAxis.index), greatestAxis ? 1 : -1)
    }
    
    static fileprivate func findLeastPenetratingAxis <T> (_ primary: Shape<T>, _ secondary: Shape<T>) -> IndexedValue<Float>? where T: Edgeform {
        let axis = findBest(0 ..< primary.form.vertices.count, -FLT_MAX, >) {
            let normal = secondary.transform.matrix.transpose * (primary.transform.matrix * primary.form.normals[$0])
            return dot(normal, secondary.form.getSupport(-normal) -
                (secondary.transform.matrix.transpose *
                (primary.getTransformedVertex($0) - secondary.transform.location)))
        }!
        return axis.value < 0 ? axis : nil
    }
    
    static fileprivate func clipIncidentFace (_ referenceFace: Face, _ incidentFace: Face) -> Face? {
        let reference_face_normal = normalize(referenceFace.vector)
        guard let halfClippedFace = clip (-reference_face_normal, -dot(reference_face_normal, referenceFace.first), incidentFace) else { return nil }
        return clip (reference_face_normal, dot(reference_face_normal, referenceFace.second), halfClippedFace)
    }
    
    static fileprivate func clip (_ face_normal: float2, _ side: Float, _ face: Face) -> Face? {
        switch (dot(face_normal, face.first) - side, dot(face_normal, face.second) - side) {
        case (let p, let s) where p < 0 && s > 0:
            return Face (face.first, face.first + alpha(p, s) * face.vector)
        case (let p, let s) where p > 0 && s < 0:
            return Face (face.second, face.first + alpha(p, s) * face.vector)
        case (let p, let s) where p < 0 && s < 0:
            return face
        default: break
        }
        return nil
    }
    
    static fileprivate func findIncidentFace <T> (_ collidingFaces: (reference: Shape<T>, incident: Shape<T>, index: Int)) -> Face where T: Edgeform {
        let reference_normal = collidingFaces.incident.transform.matrix.transpose * (collidingFaces.reference.transform.matrix * collidingFaces.reference.form.normals[collidingFaces.index])
        
        let face_index_first = findBestIndex(0 ..< collidingFaces.incident.form.vertices.count, FLT_MAX, <) {
            return dot(reference_normal, collidingFaces.incident.form.normals[$0])
            }!
        return collidingFaces.incident.getTransformedFace(face_index_first)
    }
    
    static fileprivate func resolve (_ referenceFace: Face, _ clippedIncidentFace: Face) -> (contacts: [float2], penetration: Float) {
        var contacts = [float2] ()
        let penetration = (computePenetration(referenceFace, clippedIncidentFace.first, &contacts) + computePenetration(referenceFace, clippedIncidentFace.second, &contacts)) / Float(contacts.count)
        return (contacts: contacts, penetration: penetration)
    }
    
    static fileprivate func computePenetration (_ referenceFace: Face, _ vertex: float2, _ contacts: inout [float2]) -> Float {
        let penetration = dot(referenceFace.normal, vertex) - dot(referenceFace.normal, referenceFace.first)
        guard penetration <= 0 else { return Float(0) }
        contacts.append(vertex)
        return -penetration
    }
    
}
