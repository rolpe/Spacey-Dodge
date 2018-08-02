//
//  Spaceship.swift
//  Spacey Dodge
//
//  Created by Ron Lipkin on 8/2/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import Foundation
import SpriteKit

class Spaceship {
    var mainShip:SKSpriteNode
    var speed = 0.1
    var showParticles = false
    var particlesFrameCount = 0
    var maxParticleFrames = 100
    var particles:SKEmitterNode
    
    init(node:SKSpriteNode, particles:SKEmitterNode){
        self.mainShip = node
        self.particles = particles
        
    }
}
