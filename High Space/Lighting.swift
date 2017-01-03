//
//  Lights.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/7/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

class Lighting {
    unowned let terrain: Grid
    
    var lights: [Light]
    
    init(_ terrain: Grid) {
        self.terrain = terrain
        lights = []
    }
    
    func render() {
        lights.forEach{ getFaces($0, findObjects($0, terrain)) }
        
        Graphics.shaders[1].bind()
        lights.filter(isVisible).forEach{ $0.render() }
        Graphics.bindDefault()
    }
    
    func getFaces(_ light: Light, _ objects: [Actor]) {
        let shapes = objects.map{ $0.body.shape as! Shape<Edgeform> }
        var faces = light.getFaces(shapes)
        if faces.count > 10 {
            faces = faces.sorted{ (light.location - $0.center).length < (light.location - $1.center).length }
            faces.removeSubrange(10 ..< faces.count)
        }
        light.faces = faces
    }
    
    func findObjects(_ light: Light, _ terrain: Grid) -> [Actor] {
        var objects: [Actor] = []
        terrain.cells.forEach{
            $0.elements.map{ $0.element }.filter{ Lighting.inView(light, $0) }.forEach{ objects.append($0) }
        }
        return objects
    }
    
    fileprivate static func inView(_ light: Light, _ actor: Actor) -> Bool {
        return (actor.transform.location - light.location).length < light.radius
    }
    
    fileprivate func isVisible(_ light: Light) -> Bool {
        return Camera.distance(light.location) < light.radius * 2
    }
}

class Color {
    var temperature: Float
    
    init(_ temperature: Float) {
        self.temperature = temperature
    }
    
    func computeColor(_ temperature: Float) -> float4 {
        let reduced = temperature / 100
        return float4(computeRed(reduced), computeGreen(reduced), computeBlue(reduced), 1)
    }
    
    fileprivate func computeRed(_ temperature: Float) -> Float {
        var red: Float = 1
        
        if temperature > 66 {
            red = 1.292936 * pow(temperature - 60, -0.1332047592)
        }
        
        return clamp(red, min: 0, max: 1)
    }
    
    fileprivate func computeGreen(_ temperature: Float) -> Float {
        var green: Float = 1
        
        if temperature <= 66 {
            green = 0.390081 * log(temperature) - 0.631841
        }else{
            green = 1.129890 * pow(temperature - 60, -0.0755148492)
        }
        
        return clamp(green, min: 0, max: 1)
    }
    
    fileprivate func computeBlue(_ temperature: Float) -> Float {
        var blue: Float = 1
        
        if temperature < 66 {
            if temperature <= 19 {
                blue = 0
            }else{
                blue = 0.543206 * log(temperature - 10) - 1.19625
            }
        }
        
        return clamp(blue, min: 0, max: 1)
    }
    
}






























