//
//  HomeScene.swift
//  Subpressao
//
//  Created by André Rodrigues de Jesus on 5/25/15.
//  Copyright (c) 2015 André Rodrigues de Jesus. All rights reserved.
//

import SpriteKit

var musicSounds = MusicSounds ()

class HomeScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        musicSounds.playMusic("small_fountain")
        
        
      
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: UITouch = touches.first as! UITouch
        var location = touch.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        // If previous button is touched, start transition to previous scene
        
        if (node.name == "btnJogar") {
            
            
            //            var gameScene = GameScene(size: self.size)
            var transition = SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: 1.5)
            //            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            //            self.scene!.view?.presentScene(gameScene, transition: transition)
            
            musicSounds.audioPlayer.stop()
            
            if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                // Configure the view.
                let skView = self.view as SKView!
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene, transition:transition)
            }
            
        }
    }
    
}
