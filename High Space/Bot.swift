//
//  Bot.swift
//  Raeximu
//
//  Created by Chris Luttio on 10/24/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

struct TextureReaderInfo {
    let name: String
    let subframe: float2
    let stride, limit, rate: Float
    let isRepeating: Bool
    
    init (_ name: String, _ subframe: float2, _ stride: Float, _ limit: Float, _ rate: Float, _ isRepeating: Bool = true) {
        self.name = name
        self.subframe = subframe
        self.stride = stride
        self.limit = limit
        self.rate = rate
        self.isRepeating = isRepeating
    }
}

extension Bool {
    func isTrue (@autoclosure value: () -> ()) {
        if self { value() }
    }
}

func makeBox(size: float2) -> [float2] {
    return [float2(-size.x, -size.y), float2(-size.x, size.y), float2(size.x, size.y), float2(size.x, -size.y)]
}

class Bot: Character {
    
    enum Pose: Int {
        case Running, Jumping
    }
    
    var currentPose: Pose?
    
    init(_ location: float2, _ bounds: float2, _ size: float2) {
        super.init(location, float2())
        setBody(location, bounds, size)
        generateAnimations(generateAnimationInfo())
        body.callback = { [unowned self] in
            self.getRelativeFloor($0, $1)
        }
    }
    
    func getRelativeFloor (body: Body, _ collision: Collision) {
        guard collision.normal.y > 0 else { return }
        onObject = true
    }
    
    func setBody (location: float2, _ bounds: float2, _ size: float2) {
        body = Body.box(location, bounds, Substance(Material(.Static), Mass.fixed(0.2), Friction(.Ice)))
        visual = Visual(VisualScheme(Polygon(Transform(location), makeBox(size)), VisualInfo(getTexture("white"))))
    }
    
    func determinePose () -> Pose {
        return .Running
    }
    
    override func animate (processedTime: Float) {
        currentPose = determinePose()
        let animation = getAnimation(currentPose!)
        animation.face(direction)
        animation.animate(processedTime)
    }
    
    override func update(processedTime: Float) {
        super.update(processedTime)
    }
    
    override func display() {
        setPose()
        super.display()
    }
    
    func setPose () {
        if let pose = currentPose {
            setAnimation(getAnimation(pose))
        }
    }
    
    func generateAnimationInfo () -> [TextureReaderInfo] {
        return []
    }
    
    private func generateAnimations (readerInfo: [TextureReaderInfo]) {
        for info in readerInfo {
            animations.append(TextureAnimation(info.rate, info.isRepeating, TextureReader(info)))
        }
    }
    
    func getAnimation (pose: Pose) -> TextureAnimation {
        return animations[pose.rawValue]
    }
    
}