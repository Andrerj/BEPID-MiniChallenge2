//
//  GameScene.swift
//  Subpressao
//
//  Created by André Rodrigues de Jesus on 5/21/15.
//  Copyright (c) 2015 André Rodrigues de Jesus. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        //        let alert = UIAlertView(title: "Você Sabia?", message: "A Sabesp...", delegate: self, cancelButtonTitle: "Jogar")
        //        alert.show()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: UITouch = touches.first as! UITouch
        var location = touch.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        // If next button is touched, start transition to second scene
        if (node.name == "previousbutton") {
            //            var secondScene = SecondScene(size: self.size)
            var transition = SKTransition.flipVerticalWithDuration(1.0)
            //            secondScene.scaleMode = SKSceneScaleMode.AspectFill
            //            self.scene!.view?.presentScene(secondScene, transition: transition)
            
            if let scene = HomeScene.unarchiveFromFile("HomeScene") as? HomeScene {
                // Configure the view.
                let skView = self.view as SKView!
                skView.showsFPS = true
                skView.showsNodeCount = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene, transition:transition)
                
            }
        }
    }
}