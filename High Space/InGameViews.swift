//
//  InGameViews.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 9/27/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation


class GameView: InterfaceLayer {
    var selection: Int?
    var blankslot: Display!
    
    override init() {
        blankslot = Display(Rect(float2(), float2(0.5.m)), GLTexture("white"))
        blankslot.color = float4(0.5, 0.5, 0.5, 1)
        super.init()
    }
    
    
    func makeSelection(index: Int) {
        if let sel = selection {
            if sel == index {
                selection = nil
            }else{
                selection = index
            }
        }else{
            selection = index
        }
    }
    
    func renderSlot(_ location: float2, _ index: Int) {
        blankslot.transform.location = location
        blankslot.color = float4(0.5, 0.5, 0.5, 1)
        if let sel = selection, sel == index {
            blankslot.color = float4(1, 0.5, 0.5, 1)
        }
        blankslot.visual.refresh()
        blankslot.render()
    }
    
}


class ForgeView: GameView {
    let forge: Forge
    
    init(_ forge: Forge) {
        self.forge = forge
        super.init()
        objects.append(TextButton(DynamicText.defaultStyle("game", float4(1), 64), float2(Camera.size.x / 2, 50)) {
            UserInterface.space.pop()
        })
        objects.append(TextButton(DynamicText.defaultStyle("fuse", float4(1), 64), float2(Camera.size.x / 2, 150)) {
            self.forge.combine()
        })
    }
    
    override func use(_ command: Command) {
        super.use(command)
        if let vector = command.vector {
            for n in 0 ..< forge.slots.count {
                let mask = FixedRect(computeLocation(n), float2(0.5.m))
                if mask.contains(vector + Camera.transform.location) {
                    makeSelection(index: n)
                }
            }
        }
    }
    
    func isBlank(index: Int) -> Bool {
        return forge.slots[index].item == nil
    }
    
    func append(index: Int, item: Gem) {
        forge.slots[index].item = item
    }
    
    func remove(index: Int) -> Item {
        let item = forge.slots[index].item!
        forge.slots[index].item = nil
        return item
    }
    
    override func display() {
        super.display()
        for n in 0 ..< forge.slots.count {
            let slot = forge.slots[n]
            let location = computeLocation(n)
            renderSlot(location, n)
            if let item = slot.item {
                item.transform.location = location
                item.render()
            }
        }
    }
    
    func computeLocation(_ index: Int) -> float2 {
        let spacing = 0.75.m
        let start = float2(Camera.size.x / 2 - Float(forge.slots.count - 1) * spacing / 2, Camera.size.y / 3)
        return start + float2(Float(index) * spacing, 0) + Camera.transform.location
    }
    
}

class InventoryView: GameView {
    let number: TextElement
    let width = 6
    let height = 2
    
    override init() {
        number = TextElement(float2(), DynamicText.defaultStyle(" ", float4(1), 16))
        UserInterface.controller.push(PointController(0))
    }
    
    deinit {
        UserInterface.controller.reduce()
    }
    
    override func use(_ command: Command) {
        super.use(command)
        if let vector = command.vector {
            let loc = vector + Camera.transform.location
            findSelected(loc, Score.inventory.items)
        }
    }
    
    private func findSelected(_ location: float2, _ stacks: [ItemStack]) {
        for n in 0 ..< stacks.count {
            let x = n % width
            let y = (n - x) / width
            let mask = FixedRect(computeLocation(x, y) + Camera.transform.location, float2(0.5.m))
            if mask.contains(location) {
                makeSelection(index: n)
            }
        }
    }
    
    func isBlank(index: Int) -> Bool {
        return Score.inventory.items[index].items.isEmpty
    }
    
    func remove(index: Int) -> Item {
        let item = Score.inventory.items[index].items.removeLast()
        return item
    }
    
    func append(index: Int, _ item: Item) {
        Score.inventory.items[index].items.append(item)
    }
    
    override func display() {
        
        var x = 0, y = 0
        for stack in Score.inventory.items {
            let loc = computeLocation(x, y)
            renderSlot(loc + Camera.transform.location, x + y * width)
            
            if let item = stack.items.first {
                renderItem(item, loc)
            }
            
            if x >= width - 1 {
                y += 1
                x = 0
            }else{
                x += 1
            }
            
            number.setLocation(loc + float2(30, 30))
            number.setText(DynamicText.defaultStyle("\(stack.items.count)", float4(1), 48))
            number.display()
        }
    }
    
    func renderItem(_ item: Item, _ loc: float2) {
        item.transform.location = loc + Camera.transform.location
        item.render()
    }
    
    func computeLocation(_ x: Int, _ y: Int) -> float2 {
        let spacing = 0.6.m
        let start = float2(Camera.size.x / 2 - Float(width - 1) * spacing / 2, Camera.size.y / 2 - Float(height - 1) * spacing / 2) + location
        return start + float2(Float(x), Float(y)) * spacing
    }
    
}





















