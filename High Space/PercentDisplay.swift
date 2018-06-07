//
//  PercentDisplay.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PercentDisplay {
    let status: StatusItem
    
    let transform: Transform
    let frame: Display
    let alignment: Int
    
    var blocks: [Display]
    
    let bounds: float2
    
    init(_ location: float2, _ height: Float, _ count: Int, _ alignment: Int, _ status: StatusItem) {
        self.status = status
        self.alignment = alignment
        
        blocks = []
        
        let padding: Float = 10
        let spacing: Float = 6
        
        let s = height - padding
        let width = (s + spacing) * Float(count) + spacing
        
        for i in 0 ..< count {
            let loc = location + Float(alignment) * float2(Float(i) * (s + spacing) + s / 2 + padding / 2 + 1, 0)
            let size = float2(s)
            let b = Display(Rect(loc, size), GLTexture("white"))
            b.color = status.color
            //b.camera = false
            blocks.append(b)
        }
        
        bounds = float2(width, height)
        
        frame = Display(Rect(float2(), bounds), GLTexture("white"))
        frame.color = float4(0.1, 0.1, 0.1, 1)
        
        transform = frame.scheme.schemes[0].hull.transform
        transform.assign(Camera.current.transform)
        transform.location = location + float2(width / 2 * Float(alignment), 0)
    }
    
    func move(_ delta: float2) {
        transform.location += delta
        for block in blocks {
            block.transform.location += delta
        }
    }
    
    func update() {
        status.update()
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
