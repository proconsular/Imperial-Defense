//
//  DebugInterface.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/13/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DebugShieldInterface: GameInterface {
    let map: Map
    let info: GraphicsInfo
    let line, line_top, line_bottom: GraphicsInfo
    let shield: Shield
    
    init() {
        Camera.current = Camera()
        
        map = Map(float2(20.m, 60.m))
        Map.current = map
        
        map.append(Infrantry(float2(Camera.size.x - 1.m, -Camera.size.y / 2)))
        map.append(Infrantry(float2(Camera.size.x - 1.m, -Camera.size.y * 0.9)))
        map.append(Infrantry(float2(Camera.size.x - 1.m, -Camera.size.y * 0.1)))
        
        map.append(Infrantry(float2(Camera.size.x / 2 + 1.5.m, -Camera.size.y / 2)))
        map.append(Infrantry(float2(Camera.size.x / 2 + 1.5.m, -Camera.size.y * 0.9)))
        map.append(Infrantry(float2(Camera.size.x / 2 + 1.5.m, -Camera.size.y * 0.1)))
        
        shield = Shield(50, 0.5, 0)
        
        let hull = Rect(float2(Camera.size.x / 2, -Camera.size.y / 2), float2(2.m, Camera.size.y * 0.9))
        let mat = ClassicMaterial()
        mat["texture"] = GLTexture("white").id
        mat.coordinates = HullLayout(hull).coordinates
        info = GraphicsInfo(hull, mat)
        
        let shield_mat = ShieldMaterial(shield, hull.transform, float4(0, 0, 1, 1), hull.bounds.y)
        shield_mat["texture"] = GLTexture("white").id
        info.materials.append(shield_mat)
        
        Graphics.create(info)
        
        let hull_line = Rect(float2(Camera.size.x / 2, -Camera.size.y / 2), float2(Camera.size.x, 0.1.m))
        let mat_line = ClassicMaterial()
        mat_line["texture"] = GLTexture("white").id
        mat_line["color"] = float4(0, 0, 1, 1)
        mat_line.coordinates = HullLayout(hull).coordinates
        line = GraphicsInfo(hull_line, mat_line)
        mat_line["order"] = -100
        
        Graphics.create(line)
        
        let hull_linet = Rect(float2(Camera.size.x / 2, -Camera.size.y * 0.9), float2(Camera.size.x, 0.1.m))
        let mat_linet = ClassicMaterial()
        mat_linet["texture"] = GLTexture("white").id
        mat_linet["color"] = float4(1, 0, 1, 1)
        mat_linet.coordinates = HullLayout(hull).coordinates
        line_top = GraphicsInfo(hull_linet, mat_linet)
        mat_linet["order"] = -100
        
        Graphics.create(line_top)
        
        let hull_lineb = Rect(float2(Camera.size.x / 2, -Camera.size.y * 0.1), float2(Camera.size.x, 0.1.m))
        let mat_lineb = ClassicMaterial()
        mat_lineb["texture"] = GLTexture("white").id
        mat_lineb["color"] = float4(1, 0, 0, 1)
        mat_lineb.coordinates = HullLayout(hull).coordinates
        line_bottom = GraphicsInfo(hull_lineb, mat_lineb)
        mat_lineb["order"] = -100
        
        Graphics.create(line_bottom)
        
        let height = UIScreen.main.bounds.height
        let scale = UIScreen.main.scale
        print(height)
        print(scale)
        
        print(UIScreen.main.nativeBounds.width)
        print(UIScreen.main.nativeScale)
    }
    
    func update() {
        map.update()
        
        shield.points.amount = fmodf(shield.points.amount + 5 * Time.delta, 50)
        
        map.actorate.actors.forEach{
            if let soldier = $0 as? Soldier {
                if let shield = soldier.health.shield {
                    shield.points.amount = fmodf(shield.points.amount + 0.001 * Time.delta, shield.points.limit)
                }
            }
        }
        
        Graphics.update()
    }
    
    func render() {
        Graphics.render()
    }
    
}
