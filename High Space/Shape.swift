//
//  Shape.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Shape<F: Form>: Hull {
    var transform: Transform
    var form: F
    var circle: BoundingCircle
    
    init(_ transform: Transform = Transform(), _ frame: F) {
        self.transform = transform
        self.form = frame
        circle = BoundingCircle(float2(), 0)
        computeBoundingCircle()
    }
    
    func getBounds() -> FixedRect {
        return FixedRect(float2(), float2())
    }
    
    func computeBoundingCircle() {
        let vertices = form.getVertices()
        let center = vertices.center
        let radius = findBestValue(0 ..< vertices.count, -Float.greatestFiniteMagnitude, >) {
            return (center - vertices[$0]).length
            }!
        circle = BoundingCircle(center, radius)
    }
    
    func getCircle() -> BoundingCircle {
        circle.location = transform.location
        return circle
    }
    
    func getVertices() -> [float2] {
        return form.getVertices()
    }
    
    func getTransformedVertex(_ index: Int) -> float2 {
        return getTransformedVertex(form.getVertices()[index])
    }
    
    func getTransformedVertex(_ vertex: float2) -> float2 {
        return transform.apply(vertex)
    }
    
    func getTransformedFace(_ index: Int) -> Face {
        let next = index + 1 >= form.getVertices().count ? 0 : index + 1
        return Face(getTransformedVertex(index), getTransformedVertex(next))
    }
    
}
