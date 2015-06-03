//
//  GameOverScene.swift
//  Subpressao
//
//  Created by André Rodrigues de Jesus on 5/25/15.
//  Copyright (c) 2015 André Rodrigues de Jesus. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene{
    
    var gameScene = GameScene()
    var score = 0
    var highScore = 0

//size compartilhe
//X:356,339 Y:80,048

//position
//X:387,09 y:496,338


//size tente novamente
//X:401,715 Y:76,891

//position
//X:386,514 Y:395,824
    
    var pontos: SKLabelNode?
    var recorde: SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        
        pontos = self.childNodeWithName("PontosLabel") as! SKLabelNode!
        pontos?.text = "\(gameScene.score / 10)"
        pontos?.fontName = "CutOutJams2-Regular"
        
        recorde = self.childNodeWithName("RecordeLabel") as! SKLabelNode!
        recorde?.text = "\(gameScene.recorde / 10)"
        recorde?.fontName = "CutOutJams2-Regular"
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: UITouch = touches.first as! UITouch
        var location = touch.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        // If previous button is touched, start transition to previous scene
        
        if (node.name == "TentarNovamente") {
            //            var gameScene = GameScene(size: self.size)
            var transition = SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: 1.5)
            //            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            //            self.scene!.view?.presentScene(gameScene, transition: transition)
            
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