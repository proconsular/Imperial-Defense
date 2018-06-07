//
//  StoryGateway.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class StoryGateway {
    func retrieve(name: String) -> Story {
        let story = Story()
        
        let path = Bundle.main.path(forResource: name, ofType: "txt")
        let text = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        let lines = text.components(separatedBy: CharacterSet.newlines)
        
        var screen = ""
        for line in lines {
            let cleaned_line = line.trimmed
            if cleaned_line.isEmpty { continue }
            if cleaned_line.contains(":") && cleaned_line.contains("Scene") {
                if !screen.isEmpty {
                    story.screens.append(screen.trimmed)
                    screen = ""
                }
                continue
            }
            screen += line + "\n"
        }
        if !screen.isEmpty {
            story.screens.append(screen.trimmed)
            screen = ""
        }
        
        return story
    }
}
