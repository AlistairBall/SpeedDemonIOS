//
//  GameScene.swift
//  DatabaseExample
//
//  Created by Kevin Kruusi on 2019-02-28.
//  Copyright © 2019 com.kevin.MetalWarriorsTribute. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode!
    var Time:Timer!
    var playerHealth = 3
    var bgTexture = SKTexture(imageNamed: "Road")
    var scoreLabel:SKLabelNode!
    var lives:[SKSpriteNode]!
    var score:Int = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let obstacleID:UInt32 = 0x1 << 0
    let playerBoxID:UInt32 = 0x1 << 1

    
    
    let playerController  = CMMotionManager()
    var xMovement:CGFloat = 0
    
    
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player = SKSpriteNode(imageNamed: "RedCar")
        player.name = "Player"
        player.position = CGPoint(x: frame.midX, y: frame.minY + 50 )
        self.addChild(player)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = playerBoxID
        player.physicsBody?.allowsRotation = false;

        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        Time = Timer.scheduledTimer(timeInterval: 0.65, target: self, selector: #selector(addObstacle), userInfo: nil, repeats: true)
        
        Time = Timer.scheduledTimer(timeInterval: 0.50, target: self, selector: #selector(addScore), userInfo: nil, repeats: true)

        scoreLabel = SKLabelNode(text: "Score: 0")
        //scoreLabel.zPosition = 3
        scoreLabel.position = CGPoint(x: frame.minX + 80, y: frame.maxY - 50)
        scoreLabel.fontName = "AmericanTypewriter"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor.white
        score = 0
        self.addChild(scoreLabel)

        addLives()
        makeBackground()
        
     
    }
    
    func addLives(){
        lives = [SKSpriteNode]()
        
        for live in 1 ... 3{
            let liveNode = SKSpriteNode(imageNamed: "RedCar")
            liveNode.position = CGPoint(x: (frame.maxX) - CGFloat(4 - live) * liveNode.size.width, y: frame.maxY - 50)
            liveNode.zPosition = 4
            self.addChild(liveNode)
            lives.append(liveNode)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches{
            let location = touch.location(in: self)
            for nodeHit in self.nodes(at: location){
                if nodeHit.name == "Player"{
                    player.position.x = location.x
                    
                }
                
            }
           // player.position.y = location.y
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == playerBoxID | obstacleID{
            onCollision(obstacle: contact.bodyB.node as! SKSpriteNode)
        }
        
    }
    
    @objc func addScore(){
        score += 1
    }
    
    func onCollision(obstacle:SKSpriteNode){
        if self.lives.count > 0{
            let lifeNode = self.lives.first
            lifeNode!.removeFromParent()
            self.lives.removeFirst()
        }
        if self.lives.count <= 0{
           let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOver = SKScene(fileNamed: "MainMenu") as! MainMenu
            self.view?.presentScene(gameOver, transition: transition)
           
        }
       obstacle.removeFromParent()
       score -= 10
        
    }

    
    @objc func addObstacle(){
        
        let obstacle = SKSpriteNode(imageNamed: "rock")
        
        let randomPosition = GKRandomDistribution(lowestValue: -100, highestValue: 150)
        let position = CGFloat(randomPosition.nextInt())
        
        obstacle.position = CGPoint(x: position, y: self.size.height / 2 )
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = true;
        
        obstacle.physicsBody?.categoryBitMask = obstacleID
        obstacle.physicsBody?.collisionBitMask = playerBoxID
        obstacle.physicsBody?.contactTestBitMask = playerBoxID

        
        self.addChild(obstacle)
        
        let Lifetime:TimeInterval = 5
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -self.size.height / 2), duration: Lifetime))
        actionArray.append(SKAction.removeFromParent())
        
        obstacle.run(SKAction.sequence(actionArray))
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveBackground()
        if playerHealth <= 0{
            //gameover
            player.removeFromParent()
        }

    }
    
  
    
    func makeBackground(){
        
        
        for i in 0 ... 3 {
            let Background = SKSpriteNode(texture: bgTexture)
            Background.name = "road"
            Background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
           
            Background.size.height = self.frame.height
            Background.size.width = self.frame.width
            Background.zPosition = -1
            Background.position = CGPoint(x: self.frame.midX, y: CGFloat(i) * Background.size.height)
           //  Background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            self.addChild(Background)
       
            
        }
    }
    
    func moveBackground(){
        self.enumerateChildNodes(withName: "road") { (node, error) in
            node.position.y -= 10
            if node.position.y < -((self.scene?.size.height)!){
                node.position.y += (self.scene?.size.height)! * 3
            }
        }
    }
}
