//
//  StatusLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class StatusLayer: InterfaceLayer {
    let wave: Text
    let points: Text
    
    let shield: PercentDisplay
    let weapon: PercentDisplay
    
    let background: Display
    
    let game: Game
    
    init(_ game: Game) {
        self.game = game
        let size: Float = 80
        
        shield = PercentDisplay(float2(115, size / 2), size * 0.45, 18, 1, game.player.shield)
        weapon = PercentDisplay(float2(Camera.size.x - 30, size / 2), size * 0.45, 14, -1, game.player.weapon)
        
        wave = Text(float2(300, 100), " ", FontStyle(defaultFont, float4(1), 48.0))
        points = Text(float2(Camera.size.x / 2, 5 + size / 2), " ", FontStyle(defaultFont, float4(1), 72.0 * (size / 100)))
        
        background = Display(Rect(float2(Camera.size.x / 2, size / 2), float2(Camera.size.x, size)), GLTexture("GameUIBack"))
        background.scheme.camera = false
        
        super.init()
        
        objects.append(Button(GLTexture("pause"), float2(50, size / 2), float2(size / 2), {
            UserInterface.push(PauseScreen())
        }))
    }
    
    override func display() {
        background.render()
        
        super.display()
        
        shield.render()
        
        points.setString("\(Coordinator.wave) : \(Data.info.points) : \(Data.info.bank)")
        points.render()
        
        weapon.render()
    }
}

protocol StatusItem {
    var percent: Float { get }
    var color: float4 { get }
}

class PercentDisplay {
    
    let status: StatusItem
    
    let transform: Transform
    let frame: Display
    let alignment: Int
    
    var blocks: [Display]
    
    init(_ location: float2, _ height: Float, _ count: Int, _ alignment: Int, _ status: StatusItem) {
        self.status = status
        self.alignment = alignment
        
        blocks = []
        
        let padding: Float = 10
        let spacing: Float = 6
        
        let s = height - padding
        let width = (s + spacing) * Float(count) + spacing
        
        for i in 0 ..< count {
            let b = Display(Rect(location + Float(alignment) * float2(Float(i) * (s + spacing) + s / 2 + padding / 2, 0), float2(s)), GLTexture("white"))
            b.color = status.color
            b.scheme.camera = false
            blocks.append(b)
        }
        
        frame = Display(Rect(float2(), float2(width, height)), GLTexture("white"))
        frame.color = float4(0.3, 0.3, 0.3, 1)
        
        transform = frame.scheme.hull.transform
        transform.assign(Camera.transform)
        transform.location = location + float2(width / 2 * Float(alignment), 0)
    }
   
    func render() {
        frame.render()
        let visible = clamp(Int(Float(blocks.count) * status.percent), min: 0, max: blocks.count)
        for i in 0 ..< visible {
            blocks[i].color = status.color
            blocks[i].visual.refresh()
            blocks[i].render()
        }
    }
    
}
