//
//  GameScene.swift
//  Spacey Dodge
//
//  Created by Ron Lipkin on 8/2/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let defaults = UserDefaults.standard
    
    let crashSound = SKAction.playSoundFileNamed("explosion", waitForCompletion: true)
    let wooshSound = SKAction.playSoundFileNamed("woosh", waitForCompletion: true)
    
    var ship:Spaceship!
    var touchLocationY = CGFloat() //to get touch position
    var touchLocationX = CGFloat()
    var gameOver = false
    var enemies:[Enemy] = []
    var rightBorder = CGFloat()
    var leftBorder = CGFloat()
    var topBorder = CGFloat()
    var bottomBorder = CGFloat()
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var score = 0
    var highScore = 0
    var newGame = SKSpriteNode(imageNamed: "newGame")
    var startButton = SKSpriteNode(imageNamed: "start")
    var logo = SKSpriteNode(imageNamed: "logo")
    
    
    enum ColliderType:UInt32 { //sets categories of physics bodies(1 and 2)
        case Spaceship = 1
        case Enemy = 2
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        run(crashSound)
        ship.showParticles = true
        gameOver = true
        newGame.isHidden = false
        if score > highScore {
            highScore = score
            defaults.set(score, forKey: "Highscore")
            highScoreLabel.text = "High Score: \(highScore)"
        }
    }
    
    func randomBetweenNumbers(firstNum: Float, secondNum: Float) -> Float{
        return Float(arc4random()) / Float(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    override func didMove(to view: SKView) {
        gameOver = true
        self.physicsWorld.contactDelegate = self //all contact functions will be handeled in this class
        leftBorder = (self.size.width/2) * CGFloat(-1)
        rightBorder = (self.size.width/2)
        topBorder = self.size.height/2
        bottomBorder = self.size.height/2 * CGFloat(-1)
        
        addBG()
        addSpaceship()
        addEnemies()
        
        highScore = defaults.integer(forKey: "Highscore") as Int? ?? 0
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.position.y = -(self.size.height/2.2)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
        
        highScoreLabel = SKLabelNode(text: "High Score: \(highScore)")
        highScoreLabel.fontName = "Helvetica-Bold"
        highScoreLabel.fontSize = 16
        highScoreLabel.position.y = -(self.size.height/2.2)
        highScoreLabel.position.x = -(self.size.width/2.5)
        highScoreLabel.zPosition = 1
        addChild(highScoreLabel)
        
        logo.position.y = self.frame.height/3
        logo.isHidden = false
        logo.zPosition = 2
        addChild(logo)
        
        startButton.name = "start"
        startButton.position.y = -(self.frame.height/3.3)
        startButton.zPosition = 2
        addChild(startButton)
        
        newGame.name = "newGame"
        newGame.isHidden = true
        newGame.zPosition = 2
        addChild(newGame)
    }
    
    func addBG() { //places background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.size.width = self.size.width
        background.size.height = self.size.height
        background.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        background.zPosition = 0
        addChild(background)
    }
    
    func addSpaceship() {
        let spaceship = SKSpriteNode(imageNamed: "spaceshipR")
        spaceship.physicsBody = SKPhysicsBody(texture: spaceship.texture!, size: spaceship.size)
        spaceship.physicsBody!.affectedByGravity = false
        spaceship.physicsBody!.allowsRotation = false
        spaceship.physicsBody!.categoryBitMask = ColliderType.Spaceship.rawValue //sets value to 1
        spaceship.physicsBody!.contactTestBitMask = ColliderType.Enemy.rawValue //will make contact with any value 2
        spaceship.physicsBody!.collisionBitMask = ColliderType.Enemy.rawValue //will collide with any value 2
        let shipParticles = SKEmitterNode(fileNamed: "collideParticle.sks")
        shipParticles!.isHidden = true
        ship = Spaceship(node: spaceship, particles: shipParticles!)
        spaceship.addChild(shipParticles!)
        ship.mainShip.zPosition = 1
        addChild(spaceship)
    }
    
    func addEnemies() {
        addEnemy(name:"enemy1", speed: randomBetweenNumbers(firstNum: 1.5, secondNum: 5.0), yPosition: CGFloat(self.size.height/4))
        addEnemy(name:"enemy2", speed: randomBetweenNumbers(firstNum: 1.5, secondNum: 5.0), yPosition: CGFloat(0))
        addEnemy(name:"enemy3", speed: randomBetweenNumbers(firstNum: 1.5, secondNum: 5.0), yPosition: CGFloat(-(self.size.height/4)))
        addEnemy(name:"enemy4", speed: randomBetweenNumbers(firstNum: 1.5, secondNum: 5.0), yPosition: CGFloat(-(self.size.height/3)))
        addEnemy(name:"enemy5", speed: randomBetweenNumbers(firstNum: 1.5, secondNum: 5.0), yPosition: CGFloat((self.size.height/3)))
        addEnemy(name:"enemy5", speed: randomBetweenNumbers(firstNum: 1.5, secondNum: 5.0), yPosition: CGFloat((self.size.height/2.2)))
        addEnemy(name:"enemy3", speed: randomBetweenNumbers(firstNum: 1.5, secondNum: 5.0), yPosition: CGFloat(-(self.size.height/2.2)))
    }
    
    func addEnemy(name:String, speed:Float, yPosition:CGFloat) {
        let enemyNode = SKSpriteNode(imageNamed: name)
        
        enemyNode.physicsBody = SKPhysicsBody(texture: enemyNode.texture!, size: enemyNode.size)
        enemyNode.physicsBody!.affectedByGravity = false
        enemyNode.physicsBody!.allowsRotation = false
        enemyNode.physicsBody!.categoryBitMask = ColliderType.Enemy.rawValue
        enemyNode.physicsBody!.contactTestBitMask = ColliderType.Spaceship.rawValue
        enemyNode.physicsBody!.collisionBitMask = ColliderType.Spaceship.rawValue
        
        let enemy = Enemy(speed: speed, node: enemyNode)
        enemies.append(enemy)
        resetEnemy(enemyNode: enemyNode, yPosition: yPosition)
        enemy.yPosition = enemyNode.position.y
        enemy.node.zPosition = 1
        addChild(enemyNode)
    }
    
    func resetEnemy(enemyNode:SKSpriteNode, yPosition:CGFloat) { //Starting position for new enemies
        enemyNode.position.x = rightBorder
        enemyNode.position.y = yPosition
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject? in touches {
            if !gameOver {
                run(wooshSound)
                touchLocationY = (touch!.location(in: self.view).y * -1) + (self.size.height/2)
                touchLocationX = (touch!.location(in: self.view).x) - (self.size.width/2)
                let moveAction1 = SKAction.moveTo(y: touchLocationY, duration: 0.5)
                moveAction1.timingMode = SKActionTimingMode.easeOut
                ship.mainShip.run(moveAction1)
                
                let moveAction2 = SKAction.moveTo(x: touchLocationX, duration: 0.5)
                moveAction2.timingMode = SKActionTimingMode.easeOut
                ship.mainShip.run(moveAction2)
                
                let angle = atan2(touchLocationY - ship.mainShip.position.y, touchLocationX - ship.mainShip.position.x)
                ship.mainShip.zRotation = angle - CGFloat(Double.pi/2)
            } else {
                touchLocationX = ship.mainShip.position.x //resetting player position when game is over
                touchLocationY = ship.mainShip.position.y
                let location = touch!.location(in: self)
                let sprites = nodes(at: location)
                for s in sprites {
                    if let spriteNode = s as? SKSpriteNode {
                        if spriteNode.name != nil {
                            if spriteNode.name == "newGame" || spriteNode.name == "start" {
                                reloadGame()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func reloadGame() {
        touchLocationX = 0
        touchLocationY = 0
        gameOver = false;
        ship.mainShip.position.y = 0
        ship.mainShip.position.x = 0
        ship.showParticles = false
        newGame.isHidden = true
        startButton.isHidden = true
        logo.isHidden = true
        score = 0
        scoreLabel.text = "0"
        
        ship.mainShip.zRotation = 0
        
        for enemy in enemies {
            resetEnemy(enemyNode: enemy.node, yPosition: enemy.yPosition)
            enemy.range = 2.0
            enemy.angle = 0.0
            enemy.speed = randomBetweenNumbers(firstNum: 1.5, secondNum: 5.0)
            enemy.currentFrame = 0
            enemy.setRandomFrame()
            enemy.isMoving = false
        }
    }
    
    func updateParticleEmitter() {
        if ship.showParticles && ship.particlesFrameCount < ship.maxParticleFrames {
            ship.particlesFrameCount += 1
            ship.particles.isHidden = false
        } else {
            ship.showParticles = false
            ship.particles.isHidden = true
            ship.particlesFrameCount = 0
        }
    }
    
    func updateEnemyPositions() {
        for enemy in enemies {
            if !enemy.isMoving {
                enemy.currentFrame += 1
                if enemy.currentFrame > enemy.randomFrame {
                    enemy.isMoving = true
                }
            } else {
                enemy.node.position.y = CGFloat(Double(enemy.node.position.y) + sin(enemy.angle) * enemy.range)
                enemy.angle += ship.speed
                if enemy.node.position.x > leftBorder {
                    enemy.node.position.x -= CGFloat(enemy.speed)
                } else {
                    enemy.node.position.x = rightBorder
                    enemy.currentFrame = 0
                    enemy.setRandomFrame()
                    enemy.isMoving = false
                    if enemy.range < 5 {
                        enemy.range += 0.3
                    }
                    enemy.speed += 0.3
                    updateScore()
                }
            }
        }
        
    }
    
    func updateScore(){
        score += 1
        scoreLabel.text = String(score)
        if score > highScore {
            highScoreLabel.text = "High Score: \(score)"
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !gameOver {
            updateEnemyPositions()
        }
        updateParticleEmitter()
    }
}
