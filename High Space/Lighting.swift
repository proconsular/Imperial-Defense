//
//  Lights.swift
//  Bot Bounce 2
//
//  Created by Chris Luttio on 5/7/16.
//  Copyright © 2016 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Lighting {
    unowned let terrain: Terrain
    
    var lights: [Light]
    
    init(_ terrain: Terrain) {
        self.terrain = terrain
        lights = []
    }
    
    func render() {
        lights.forEach{ getFaces($0, findObjects($0, terrain)) }
        
        Graphics.shaders[1].bind()
        lights.filter(isVisible).forEach{ $0.render() }
        Graphics.bindDefault()
    }
    
    func getFaces(light: Light, _ objects: [Physical]) {
        let shapes = objects.map{ $0.getBody().shape as! Shape<Edgeform> }
        let faces = light.getFaces(shapes)
        light.faces = faces
    }
    
    func findObjects(light: Light, _ terrain: Terrain) -> [Physical] {
        var objects: [Physical] = []
        terrain.foreach{
            $0.platforms.filter{ Lighting.inView(light, $0) }.forEach{ objects.append($0) }
        }
        return objects
    }
    
    private static func inView(light: Light, _ platform: Platform) -> Bool {
        return (platform.location - light.location).length - platform.length < light.radius
    }
    
    private func isVisible(light: Light) -> Bool {
        return Camera.distance(light.location) < light.radius * 2
    }
    
}

class Color {
    var temperature: Float
    
    init(_ temperature: Float) {
        self.temperature = temperature
    }
    
    func computeColor(temperature: Float) -> float4 {
        let reduced = temperature / 100
        return float4(computeRed(reduced), computeGreen(reduced), computeBlue(reduced), 1)
    }
    
    private func computeRed(temperature: Float) -> Float {
        var red: Float = 1
        
        if temperature > 66 {
            red = 1.292936 * pow(temperature - 60, -0.1332047592)
        }
        
        return clamp(red, min: 0, max: 1)
    }
    
    private func computeGreen(temperature: Float) -> Float {
        var green: Float = 1
        
        if temperature <= 66 {
            green = 0.390081 * log(temperature) - 0.631841
        }else{
            green = 1.129890 * pow(temperature - 60, -0.0755148492)
        }
        
        return clamp(green, min: 0, max: 1)
    }
    
    private func computeBlue(temperature: Float) -> Float {
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






























