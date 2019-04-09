//
//  MainMenu.swift
//  DatabaseExample
//
//  Created by media on 2019-04-09.
//  Copyright © 2019 com.kevin.MetalWarriorsTribute. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    var newGameButton:SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        
        newGameButton = self.childNode(withName: "NewGame") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodes = self.nodes(at: location)
            
            if nodes.first?.name == "NewGame"{
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let game = GameScene(size: self.size)
                self.view?.presentScene(game, transition: transition)
            }
        }
        
    }
    
}
