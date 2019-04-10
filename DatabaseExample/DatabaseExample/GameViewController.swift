//
//  GameViewController.swift
//  DatabaseExample
//
//  Created by Kevin Kruusi on 2019-02-28.
//  Copyright © 2019 com.kevin.MetalWarriorsTribute. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

struct Action {
    let name: String
    let castType: String
    let duration: Float
    let effects: [String: Any]?
    let type: String
    
    func toAnyObject() -> [String: Any?] {
        return ["name": name,
                "castType": castType,
                "duration": duration,
                "effects": effects,
                "type": type]
    }
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //wrapper i wrote for firebase db very simple. Check this class for implementation details
        let database = RealtimeDB()
        var actionsDatabaseSnapshot: [String: Any?] = [:]
        
        // reading (uses a closure because it is an asynchronous action)
        database.getActions { (actionsDictionary) in
            actionsDatabaseSnapshot = actionsDictionary
            print(actionsDatabaseSnapshot)
        }
        
        // struct representing a custom class
        let jumpAction = Action.init(name: "jump", castType: "instant", duration: 2.0, effects: nil, type: "ability")
        
        // writing (will fail because I have turned off write access, but the implementation is correct)
//        database.add(action: jumpAction)        
        
        // nothing below here is related to Databases.
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MainMenu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
