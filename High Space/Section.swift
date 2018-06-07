//
//  Section.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
