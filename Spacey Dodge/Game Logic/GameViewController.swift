//
//  GameViewController.swift
//  Spacey Dodge
//
//  Created by Ron Lipkin on 8/2/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MusicHelper.sharedHelper.playSound(name: "SpaceEvaders", fileExtension: "mp3")
        
    }
    
    override func viewDidLayoutSubviews() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) //sets default entry point at center of screen
                scene.size = view.bounds.size //sets scene size to full size of screen
                
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
