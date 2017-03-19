//
//  TitleUI.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/17/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class FriendsDisplay: InterfaceElement {
    
    var location: float2
    
    var friends: [FriendView]
    
    init() {
        location = float2()
        
        friends = []
        
        let width = 3
        let height = 2
        
        let spacing = float2(500, 300)
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                let rx = Camera.size.x / 2 + (Float(x) - Float(width - 1) / 2) * spacing.x
                let ry = Camera.size.y / 2 + (Float(y) - Float(height - 1) / 2) * spacing.y
                let friend = FriendView(float2(rx, ry))
                friends.append(friend)
            }
        }
    }
    
    func render() {
        friends.forEach{ $0.render() }
    }
    
}

class FriendView {
    
    let background: Display
    let name: Text
    let points: Text
    
    init(_ location: float2) {
        background = Display(Rect(location, float2(200)), GLTexture())
        background.color = float4(0, 0, 1, 1)
        name = Text(location, "Jimmy", defaultStyle)
        points = Text(location + float2(0, 100), "Points 400", defaultStyle)
    }
    
    func render() {
        background.render()
        name.render()
        points.render()
    }
    
}


class NewsDisplay: InterfaceElement {
    
    var location: float2
    
    var headlines: [NewsView]
    
    init() {
        location = float2()
        
        headlines = []
        
        let spacing: Float = 250
        let count = 3
        for i in 0 ..< count {
            let d = (Float(i) - Float(count - 1) / 2)
            let ry = Camera.size.y / 2 + d * spacing
            let headline = NewsView(float2(Camera.size.x / 2, ry))
            headlines.append(headline)
        }
    }
    
    func render() {
        headlines.forEach{ $0.render() }
    }
    
}

class NewsView {
    
    let background: Display
    let headline: Text
    let body: Text
    
    init(_ location: float2) {
        let size = float2(Camera.size.x * 0.8, 200)
        
        background = Display(Rect(location, size), GLTexture())
        background.color = float4(0, 0, 1, 1)
        headline = Text(location + float2(0, -size.y / 2), "Update 1.1", defaultStyle)
        let string = "Praesent eu purus ante. Nam dictum commodo dui ut accumsan. Vestibulum at lorem at diam vestibulum vulputate in nec nibh. Curabitur nec volutpat lectus, et eleifend felis. Aenean nec elementum orci, quis porttitor lorem."
        let bodystyle = FontStyle(defaultFont, float4(1), 48.0)
        body = Text(location, string, bodystyle, size / 4)
    }
    
    func render() {
        background.render()
        headline.render()
        body.render()
    }
    
}

class GameDisplay: InterfaceElement, Interface {
    
    var location: float2
    let background: Display
    let info: InfoDisplay
    
    let reset: TextButton
    let upgrades: TextButton
    
    var alpha: Float
    
    init() {
        alpha = 1
        location = float2()
        background = Display(Rect(Camera.size / 2, Camera.size), GLTexture())
        background.color = float4(0.1, 0.1, 0.1, 1)
        background.camera = false
        info = InfoDisplay(float2(Camera.size.x / 2, Camera.size.y / 2))
       
        upgrades = TextButton(Text("upgrades", FontStyle(defaultFont, float4(1), 48.0)), float2(Camera.size.x / 2 - 150, Camera.size.y / 2 + 100)) {
            UserInterface.space.wipe()
            UserInterface.space.push(StoreScreen())
        }
        
        reset = TextButton(Text("reset", FontStyle(defaultFont, float4(1), 48.0)), float2(Camera.size.x / 2 + 150, Camera.size.y / 2 + 100)) {
            GameData.info = GameInfo.Default
            GameData.persist()
        }
    }
    
    func use(_ command: Command) {
        upgrades.use(command)
        reset.use(command)
    }
    
    func render() {
        //background.color = float4(1, 1, 1, alpha)
        //background.visual.refresh()
        background.render()
        //info.text.text.display.color = float4(1, 1, 1, alpha)
        //info.text.text.display.refresh()
        info.render()
        reset.render()
        upgrades.render()
    }
    
}

class InfoDisplay {
    
    let text: Text
    
    init(_ location: float2) {
        text = Text(location, " ", FontStyle(defaultFont, float4(1), 72.0))
    }
    
    func render() {
        text.setString("Level \(GameData.info.level + 1) Points \(GameData.info.points)")
        text.render()
    }
    
}






