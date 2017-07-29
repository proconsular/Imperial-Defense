//
//  Story.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/28/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Story {
    var screens: [String]
    
    init() {
        screens = []
    }
    
}

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
            if cleaned_line.contains(":") && cleaned_line.contains("Screen") {
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

class ParsedTextGateway {
    
    func retrieve(name: String) -> ParsedText {
        let parsed = ParsedText()
        
        let path = Bundle.main.path(forResource: name, ofType: "txt")
        let text = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        let lines = text.components(separatedBy: CharacterSet.newlines)
        
        for line in lines {
            let cleaned_line = line.trimmed
            if cleaned_line.isEmpty { continue }
            if cleaned_line.contains("--") {
                parsed.sections.append(Section())
            }else if cleaned_line.contains("==") {
            }else{
                parsed.sections.last?.lines.append(cleaned_line)
            }
        }
        
        return parsed
    }
    
}

class ParsedText {
    
    var sections: [Section]
    
    init() {
        sections = []
    }
    
}

class Section {
    var lines: [String]
    
    init() {
        lines = []
    }
    
    var text: String {
        var output = ""
        for line in lines {
            output += line + "\n"
        }
        return output.trimmed
    }
}




















