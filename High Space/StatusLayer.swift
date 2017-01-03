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
    let laser: PercentDisplay
    
    init(_ game: Game) {
        shield = PercentDisplay(float2(135, 25), float2(400, 22.5), 1, game.player.shield)
        laser = PercentDisplay(float2(Camera.size.x - 30, 30), float2(550, 15), -1, game.player.laser)
        
        wave = Text(float2(300, 100), " ", FontStyle(defaultFont, float4(1), 48.0))
        points = Text(float2(Camera.size.x / 2, 60), " ", FontStyle(defaultFont, float4(1), 72.0))
        
        super.init()
        
        objects.append(TextButton(Text("II"), float2(50), {
            UserInterface.push(PauseScreen())
        }))
    }
    
    override func display() {
        super.display()
        
        shield.render()
        
        wave.setString("level: \(Data.info.level)")
        wave.render()
        
        points.setString("\(Data.info.points)")
        points.render()
        
        laser.render()
    }
}

protocol StatusItem {
    var percent: Float { get }
}

class PercentDisplay {
    
    let status: StatusItem
    
    let transform: Transform
    let frame, level: Display
    let rect: Rect
    let size: float2
    let alignment: Int
    
    init(_ location: float2, _ size: float2, _ alignment: Int, _ status: StatusItem) {
        self.status = status
        self.size = size
        self.alignment = alignment
        
        frame = Display(Rect(float2(), size), GLTexture("white"))
        frame.color = float4(0.3, 0.3, 0.3, 0.2)
        
        rect = Rect(float2(), float2(size.x, size.y))
        level = Display(rect, GLTexture("white"))
        level.color = float4(0.4, 1, 0.5, 1)
        
        transform = frame.scheme.hull.transform
        transform.assign(Camera.transform)
        transform.location = location + float2(size.x / 2 * Float(alignment), 0)
        
        rect.transform.assign(transform)
    }
    
    func render() {
        let adjust = size.x * status.percent
        rect.setBounds(float2(adjust, size.y))
        rect.transform.location.x = Float(alignment) * (-size.x / 2 + adjust / 2)
        
        level.visual.refresh()
        frame.render()
        level.render()
    }
    
}
