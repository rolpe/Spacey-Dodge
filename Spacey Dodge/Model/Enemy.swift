//
//  Enemy.swift
//  Spacey Dodge
//
//  Created by Ron Lipkin on 8/2/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy {
    var speed:Float = 0.0
    var node:SKSpriteNode
    var currentFrame = 0
    var randomFrame = 0
    var isMoving = false
    var angle = 0.0
    var range = 2.0
    var yPosition = CGFloat()
    
    init(speed:Float, node:SKSpriteNode) {
        self.speed = speed
        self.node = node
        self.setRandomFrame()
    }
    
    func setRandomFrame() { //gets random Int between 50 and 200 and assigns it to randomFrame
        let range = UInt32(50)..<UInt32(200)
        self.randomFrame = Int(range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1))
    }
}
