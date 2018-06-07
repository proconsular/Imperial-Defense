//
//  StoryQuote.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class StoryQuote {
    var lines: [Text]
    
    convenience init(_ story: String) {
        self.init(story, float2(Camera.size.x / 2, Camera.size.y / 2) + float2(0, -GameScreen.size.y) + float2(0, -Camera.size.y * 0.05))
    }
    
    init(_ story: String, _ location: float2) {
        let style = FontStyle(defaultFont, float4(1), 52.0)
        lines = []
        var l = story.components(separatedBy: "\n")
        var quote = ""
        if let last = l.last {
            if last.hasPrefix("–") {
                quote = last
                l.removeLast()
            }
        }
        let spacing: Float = 65
        for n in 0 ..< l.count {
            let line = l[n]
            if line.trimmed == "" { continue }
            let text = Text(line, style)
            text.location = location + float2(0, Float(n) * spacing - Float(l.count) / 2 * spacing + spacing / 2)
            lines.append(text)
        }
        
        if quote != "" {
            let text = Text(quote, style)
            text.location = location + float2(0, spacing * 3)
            lines.append(text)
        }
    }
    
    func render() {
        for line in lines {
            line.render()
        }
    }
    
    func contains(_ word: String) -> Bool {
        for line in lines {
            if line.string.lowercased().contains(word) {
                return true
            }
        }
        return false
    }
}
