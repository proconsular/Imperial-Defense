//
//  Gateway.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/20/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

typealias KeyValuePair = (String, AnyObject)

protocol Retrievable {
    var name: String { get }
}

protocol Info: Retrievable {
    var pack: String { get }
    init(_ name: String, _ pack: String, _ data: [String: AnyObject])
}

class PackElement {
    
    let name: String
    let pack: String
    
    init(_ name: String, _ pack: String) {
        self.name = name
        self.pack = pack
    }
    
}

class Gateway<T: Retrievable> {
    
    func retrieve(name: String) -> T! {
        return nil
    }
    
    func persist(object: T) {
        
    }
    
}

class InfoGateway<I: Info>: Gateway<I> {
    
    let pack: String
    let packdata: [String: AnyObject]
    
    init(prefix: String, _ pack: String) {
        self.pack = pack
        let path = NSBundle.mainBundle().URLForResource(prefix + pack, withExtension: "plist")!
        self.packdata = NSDictionary(contentsOfURL: path)! as! [String: AnyObject]
    }
    
    override func retrieve(name: String) -> I! {
        let data = packdata[name]! as! [String: AnyObject]
        return I(name, pack, data)
    }
    
}

class UserProfile: Retrievable {
    
    let name: String
    
    var level: Int
    var points: [Int]
    var difficulty: Int
    
    init(name: String) {
        self.name = name
        level = 0
        difficulty = 1
        points = Array<Int>(count: 7, repeatedValue: 0)
    }
    
    init(_ name: String, _ data: [String: AnyObject]) {
        self.name = name
        level = data["level"] as! Int
        points = data["points"] as! [Int]
        difficulty = data["difficulty"] as! Int
    }
    
    var toData: NSDictionary {
        return NSDictionary(dictionary: ["level": level, "difficulty": difficulty, "points": points])
    }
    
    func updatePoints(level: Int, _ amount: Int) {
        if points[level] < amount {
            points[level] = amount
        }
    }
    
    func updateLevel(level: Int) {
        if self.level == level {
            self.level += 1
        }
    }
    
}

class ProfileGateway: Gateway<UserProfile> {
    
    func exists(path: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    func createDirectory() {
        guard !exists(directory) else { return }
        try! NSFileManager.defaultManager().createDirectoryAtPath(directory, withIntermediateDirectories: true, attributes: nil)
    }
    
    override func retrieve(name: String) -> UserProfile! {
        let data = NSDictionary(contentsOfFile: getPath(name) + ".plist") as! [String: AnyObject]
        return UserProfile(name, data)
    }
    
    override func persist(object: UserProfile) {
        object.toData.writeToFile(getPath(object.name) + ".plist", atomically: true)
    }
    
    private var directory: String {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        return path.stringByAppendingPathComponent("profiles")
    }
    
    func getPath(name: String) -> String {
        return (directory as NSString).stringByAppendingPathComponent(name)
    }
    
}

class PowerupInfo: PackElement, Info {
    
    let color: float4
    let rate: Float
    
    required init(_ name: String, _ pack: String, _ data: [String : AnyObject]) {
        let array = data["color"] as! [Float]
        self.color = float4(array[0], array[1], array[2], 1)
        self.rate = data["rate"] as! Float
        
        super.init(name, pack)
    }
    
}

class PowerupInfoGateway: InfoGateway<PowerupInfo> {
    
    init(_ pack: String) {
        super.init(prefix: "powerup_", pack)
    }
    
}

class BotInfo: PackElement, Info {
    
    let size: Float
    let frame: float2
    
    required init(_ name: String, _ pack: String, _ data: [String: AnyObject]) {
        self.size = data["size"] as! Float
        let array = data["frame"] as! [Float]
        self.frame = float2(array[0], array[1])
        
        super.init(name, pack)
    }
    
}

class BotInfoGateway: InfoGateway<BotInfo> {
    
    init(_ pack: String) {
        super.init(prefix: "enemy_", pack)
    }
    
}

class LevelInfo: PackElement, Info {
    
    let title: String
    let color: float4
    let order: Int
    let hasFloor: Bool
    let characters: [String]
    let powerup: String
    
    required init(_ name: String, _ pack: String, _ data: [String: AnyObject]) {
        self.title = data["title"] as! String
        self.order = data["order"] as! Int
        self.hasFloor = data["floor"] as! Bool
        self.characters = data["characters"] as! [String]
        self.powerup = data["powerup"] as! String
        
        let array = data["color"] as! [Float]
        self.color = float4(array[0], array[1], array[2], 1)
        
        super.init(name, pack)
    }
    
}

class LevelInfoGateway: InfoGateway<LevelInfo> {
    
    var levelnames: [String] = []
    
    init(pack: String) {
        super.init(prefix: "level_", pack)
        levelnames = []
        let data = packdata.sort(sortNames)
        for (key, _) in data {
            levelnames.append(key)
        }
    }
    
    private func sortNames (prime: KeyValuePair, secunde: KeyValuePair) -> Bool {
        let pd = prime.1 as! [String: AnyObject]
        let po = pd["order"] as! Int
        let sd = secunde.1 as! [String: AnyObject]
        let so = sd["order"] as! Int
        return po < so
    }
    
    func after (name: String) -> String {
        let index = levelnames.indexOf(name)!
        return levelnames[index + 1]
    }
    
    func retrieveAfter(name: String) -> LevelInfo {
        return retrieve(after(name))
    }
    
}