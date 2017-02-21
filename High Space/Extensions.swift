//
//  extensions.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/16/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

extension Array where Element: AnyObject {
    
    mutating func removeObject(_ element: Element) {
        for n in 0 ..< self.count {
            if self[n] === element {
                self.remove(at: n)
                return
            }
        }
    }
    
}
