//
//  SaveDisplay.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/1/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SaveDisplay: Entity, Damagable {
    var reflective: Bool = false
    
    var top: Display
    var bottom: Display
    var legion: Text
    var points: Text
    
    var location: float2
    let save_bounds: float2
    
    var vel: Float
    var delta: Float
    var direction: Float
    
    var opacity: Float = 1
    var deleted = false
    
    init(_ location: float2) {
        self.location = location
        delta = 0
        vel = 0
        direction = 1
        save_bounds = float2(32, 16) * 10
        let top_loc = location - float2(0, save_bounds.y / 4)
        let bot_loc = location + float2(0, save_bounds.y / 4)
        top = Display(top_loc, save_bounds / 2, GLTexture("SaveFile"))
        top.coordinates = SheetLayout(0, 1, 2).coordinates
        bottom = Display(bot_loc, save_bounds / 2, GLTexture("SaveFile"))
        bottom.coordinates = SheetLayout(1, 1, 2).coordinates
        let style = FontStyle(defaultFont, float4(1, 1, 1, 1), 20)
        legion = Text(top_loc + float2(0, -GameScreen.size.y) + float2(0, 5), "0", style)
        points = Text(bot_loc + float2(0, -GameScreen.size.y) + float2(0, -20), "0", style)
        
        let rect = Rect(location + float2(0, -GameScreen.size.y), float2(16, 32) * 10)
        super.init(Rect(rect.transform, float2()), rect, Substance.getStandard(1))
        
        body.tag = "save"
        body.object = self
        body.mask = 0b10
        
        reaction = DamageReaction(self)
    }
    
    func damage(_ amount: Float) {
        
    }
    
    func delete() {
        deleted = true
    }
    
    override func update() {
        if deleted {
            opacity -= 2 * Time.delta
            top.color = float4(opacity)
            top.refresh()
            bottom.color = float4(opacity)
            bottom.refresh()
            legion.color = float4(opacity)
            legion.text.display.refresh()
            points.color = float4(opacity)
            points.text.display.refresh()
            if opacity <= 0 {
                alive = false
                GameData.reset()
            }
        }
    }
    
    override func render() {
        if !alive { return }
        top.render()
        bottom.render()
        var st = "\((GameData.info.wave + 1).roman)"
        if GameData.info.wave >= 100 {
            st = "???"
        }
        legion.setString(st)
        legion.render()
        points.setString("\(GameData.info.points)")
        points.render()
    }
    
}
