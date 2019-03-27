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
    var bgTexture = SKTexture(imageNamed: "Road")
    var scoreLabel:SKLabelNode!
    var score:Int = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
   
    //let playerBoxID:Uint32 = 0x1 << 2
    let obstacleID:UInt32 = 0x1 << 1
    let playerBoxID:UInt32 = 0x1 << 0
    
    let playerController  = CMMotionManager()
    var xMovement:CGFloat = 0
    
    
    
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player = SKSpriteNode(imageNamed: "RedCar")
       player.name = "Player"
        player.position = CGPoint(x: frame.midX, y: player.size.height - 600 )
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        Time = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addObstacle), userInfo: nil, repeats: true)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        //scoreLabel.zPosition = 3
        scoreLabel.position = CGPoint(x: player.position.x, y: player.position.y)
        scoreLabel.fontName = "AmericanTypewriter"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = UIColor.black
        score = 0
        makeBackground()
        
        
     
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    @objc func addObstacle(){
        
        let obstacle = SKSpriteNode(imageNamed: "rock")
        
        let randomPosition = GKRandomDistribution(lowestValue: -220, highestValue: 220)
        let position = CGFloat(randomPosition.nextInt())
        
        obstacle.position = CGPoint(x: position, y: self.size.height / 2 )
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = true;
        
        obstacle.physicsBody?.categoryBitMask = obstacleID
        obstacle.physicsBody?.contactTestBitMask = playerBoxID
        obstacle.physicsBody?.collisionBitMask = 0
        
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
