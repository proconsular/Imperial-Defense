//
//  Tutorial.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/14/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Tutorial {
    
    let left, right, overscreen: Display
    let move, shoot, health, fire: Text
    let move_des, shoot_des, health_des, fire_des, end, challenge_text: Text
    
    let moveInput: ShowInput
    let shootInput: ShowInput
    
    let shield_pointer, fire_pointer: ShowPointer
    
    var again, play, start: TextButton!
    
    var velocity: float2
    
    unowned let controller: PlayerInterface
    
    var mode: Int = 1
    var counter: Float = 0
    
    var wait: Float = 2
    
    let challenge: Selection
    
    init(_ controller: PlayerInterface) {
        self.controller = controller
        
        velocity = float2(0.025.m, 0)
        
        left = Display(Rect(float2(Camera.size.x / 4, Camera.size.y / 2 - Camera.size.y), float2(Camera.size.x / 2, Camera.size.y)), GLTexture())
        left.color = float4(0.9, 0.3, 0.3, 1) * 0.5
        
        right = Display(Rect(float2(Camera.size.x * 0.75, Camera.size.y / 2 - Camera.size.y), float2(Camera.size.x / 2, Camera.size.y)), GLTexture())
        right.color = float4(0.3, 0.3, 0.9, 1) * 0.5
        
        overscreen = Display(Rect(float2(Camera.size.x / 2, Camera.size.y / 2 - Camera.size.y), Camera.size), GLTexture())
        overscreen.color = float4(0.3, 0.9, 0.3, 1) * 0.1
        
        move = Text(float2(Camera.size.x / 4, Camera.size.y / 3 - Camera.size.y), "Move", FontStyle(defaultFont, float4(1), 144))
        shoot = Text(float2(Camera.size.x * 0.75, Camera.size.y / 3 - Camera.size.y), "Shoot", FontStyle(defaultFont, float4(1), 144))
        health = Text(float2(Camera.size.x / 2, Camera.size.y / 3 - Camera.size.y), "Shield", FontStyle(defaultFont, float4(1), 144))
        fire = Text(float2(Camera.size.x / 2, Camera.size.y / 3 - Camera.size.y), "Firing", FontStyle(defaultFont, float4(1), 144))
        
        end = Text(float2(Camera.size.x / 2, Camera.size.y / 4 - Camera.size.y), "Are you ready?", FontStyle(defaultFont, float4(1), 104))
        challenge_text = Text(float2(Camera.size.x / 2, Camera.size.y / 4 - Camera.size.y), "Level of Challenge?", FontStyle(defaultFont, float4(1), 104))
        
        move_des = Text(float2(Camera.size.x / 4, Camera.size.y * 0.66 - Camera.size.y), "Drag in area to move.", FontStyle(defaultFont, float4(1), 54))
        shoot_des = Text(float2(Camera.size.x * 0.75, Camera.size.y * 0.66 - Camera.size.y), "Tap or Hold in area to shoot.", FontStyle(defaultFont, float4(1), 54))
        health_des = Text(float2(Camera.size.x / 2, Camera.size.y / 2 - Camera.size.y), "Wait for shield recharge.", FontStyle(defaultFont, float4(1), 54))
        fire_des = Text(float2(Camera.size.x / 2, Camera.size.y / 2 - Camera.size.y), "Maintain firepower to shoot consistently.", FontStyle(defaultFont, float4(1), 54))
        
        moveInput = ShowInput(float2(Camera.size.x / 4, Camera.size.y / 2 - Camera.size.y), 1.m)
        shootInput = ShowInput(float2(Camera.size.x * 0.75, Camera.size.y / 2 - Camera.size.y), 1.m)
        
        shield_pointer = ShowPointer(float2(Camera.size.x * 0.13, -Camera.size.y * 0.85))
        fire_pointer = ShowPointer(float2(Camera.size.x * 0.905, -Camera.size.y * 0.85))
        
        let vert = float2(0, 150)
        let off = float2(0, 50)
        
        let list = ["Least", "Lesser", "True"]
        challenge = Selection(float2(Camera.size.x / 2, Camera.size.y / 2 - Camera.size.y) - vert + off, 400, list)
        
        again = TextButton(Text("Show Again"), float2(Camera.size.x / 4, -Camera.size.y * 0.5)) { [unowned self] in
            self.mode = 1
            UserInterface.controller.reduce()
            controller.unfreeze()
        }
        play = TextButton(Text("Play Game"), float2(Camera.size.x * 0.75, -Camera.size.y * 0.5)) { [unowned self] in
            self.mode = 9
        }
        start = TextButton(Text("Start"), float2(Camera.size.x * 0.5, -Camera.size.y * 0.33)) { [unowned self] in
            self.mode = 0
            UserInterface.controller.reduce()
            controller.unfreeze()
        }
        
        challenge.select(GameData.info.challenge + 2)
        
    }
    
    var isComplete: Bool {
        return mode == 0
    }
    
    func use(_ command: Command) {
        if command.id == 0 {
            if mode == 8 {
                again.use(command)
                play.use(command)
            }
            if mode == 9 {
                start.use(command)
                for button in challenge.buttons {
                    button.use(command)
                }
            }
        }
    }
    
    func update() {
        
        if mode == 0 {
            
        }else if mode == 1 {
            counter += Time.delta
            if counter >= 0.2 {
                counter = 0
                left.color = left.color.w == 0 ? float4(0.9, 0.3, 0.3, 1) * 0.5 : float4(0)
            }
            
            wait -= Time.delta
            if wait <= 0 {
                mode += 1
                wait = 5
                counter = 0
                left.color = float4(0.9, 0.3, 0.3, 1) * 0.5
            }
        }else if mode == 2 {
            showMove()
            
            wait -= Time.delta
            if wait <= 0 {
                mode += 1
                wait = 2
            }
        }else if mode == 3 {
            counter += Time.delta
            if counter >= 0.2 {
                counter = 0
                right.color = right.color.w == 0 ? float4(0.3, 0.3, 0.9, 1) * 0.5 : float4(0)
            }
            
            wait -= Time.delta
            if wait <= 0 {
                mode += 1
                wait = 5
                counter = 0
                right.color = float4(0.3, 0.3, 0.9, 1) * 0.5
            }
        }else if mode == 4 {
            showShoot(0.5)
            
            wait -= Time.delta
            if wait <= 0 {
                mode += 1
                wait = 4
            }
        }else if mode == 5 {
            showMove()
            showShoot(0.5)
            
            wait -= Time.delta
            if wait <= 0 {
                mode += 1
                wait = 8
                counter = 0
                overscreen.color = float4(0.3, 0.9, 0.3, 1) * 0.1
            }
        }else if mode == 6 {
            if counter == 0 {
                controller.player!.damage(controller.player!.health.shield!.points.amount)
                counter = 1
            }
            shield_pointer.update()
            wait -= Time.delta
            if wait <= 0 {
                mode += 1
                wait = 8
                counter = 0
                overscreen.color = float4(0.9, 0.9, 0.3, 1) * 0.1
            }
        }else if mode == 7 {
            showShoot(1)
            fire_pointer.update()
            wait -= Time.delta
            if wait <= 0 {
                mode += 1
                wait = 5
                counter = 0
                Trigger.clear()
                UserInterface.controller.push(PointController(0))
                controller.freeze()
            }
        }else if mode == 9 {
            let c = GameData.info.challenge
            if c != challenge.index - 2 {
                GameData.info.challenge = challenge.index - 2
                GameData.persist()
            }
        }
    }
    
    func showMove() {
        let x = moveInput.transform.location.x
        if x <= Camera.size.x / 4 - 100 {
            velocity.x = 0.025.m
        }else if x >= Camera.size.x / 4 + 100 {
            velocity.x = -0.025.m
        }
        
        moveInput.transform.location += velocity
        
        var moveCommand = Command(0)
        moveCommand.vector = velocity * 200
        controller.use(moveCommand)
    }
    
    func showShoot(_ amount: Float) {
        counter += Time.delta
        if counter >= amount {
            counter = 0
            shootInput.color = shootInput.color.w == 0.25 ? float4(1) : float4(0.25)
        }
        
        if shootInput.color.w == 1 {
            controller.use(Command(1))
        }
    }
    
    func render() {
        
        if mode == 1 || mode == 2 || mode == 5 {
            left.refresh()
            left.render()
            move.render()
        }
        
        if mode == 3 || mode == 4 || mode == 5 {
            right.refresh()
            right.render()
            shoot.render()
        }
        
        if mode == 2 || mode == 5 {
            moveInput.render()
            move_des.render()
        }
        
        if mode == 4 || mode == 5 {
            shootInput.render()
            shoot_des.render()
        }
        
        if mode == 6 {
            overscreen.refresh()
            overscreen.render()
            health.render()
            health_des.render()
            shield_pointer.render()
        }
        
        if mode == 7 {
            overscreen.refresh()
            overscreen.render()
            fire.render()
            fire_des.render()
            fire_pointer.render()
        }
        
        if mode == 8 {
            end.render()
            again.render()
            play.render()
        }
        
        if mode == 9 {
            challenge_text.render()
            start.render()
            for button in challenge.buttons {
                button.render()
            }
        }
    }
    
}




























