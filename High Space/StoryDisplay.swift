//
//  StoryDisplay.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class StoryDisplay: StoryElement {
    var quotes: [StoryQuote]
    var index: Int
    
    init(_ level: Int) {
        index = 0
        var story = "Unwritten Story Screen"
        if level < GameData.info.story.screens.count {
            story = GameData.info.story.screens[level]
        }
        quotes = []
        
        let qs = story.components(separatedBy: "~")
        
        for q in qs where q.trimmed != "" {
            quotes.append(StoryQuote(q))
        }
    }
    
    func update() {
        
    }
    
    func render() {
        quotes[index].render()
    }
}
