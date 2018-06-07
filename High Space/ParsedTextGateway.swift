//
//  ParsedTextGateway.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
