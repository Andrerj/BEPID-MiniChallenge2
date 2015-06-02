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
    
    var moveSpriteAndDestroy: SKAction?
    var lastSpawn:CFTimeInterval = 0;
    
    var holeTexture:SKTexture?
    
    override func didMoveToView(view: SKView) {

        
        setImages(SKTexture(imageNamed: "lateral1"), Tex2: SKTexture(imageNamed: "lateral2"), zIndex: 3)
        setImages(SKTexture(imageNamed: "cano1"), Tex2: SKTexture(imageNamed: "cano2"), zIndex: 0)
        
        //160,717
        //629,385
        
        holeTexture = SKTexture(imageNamed:"hole")
    }
    
    func setImages(Tex: SKTexture, Tex2: SKTexture, zIndex: Int){
        var backgroundNode = SKNode()
        var backTex = Tex
        var backTex2 = Tex2
        
        let scaleValue:CGFloat = self.frame.size.height/backTex.size().height
        
        var moveSkySprite = SKAction.moveByX(0, y: -backTex.size().height * 2 * scaleValue, duration: NSTimeInterval(0.01 * backTex.size().height * scaleValue))
        
        var resetSkySprite = SKAction.moveByX(0, y: backTex.size().height * 2 * scaleValue, duration: 0.0)
        
        var moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite]))//, resetSkySprite]))
        
        moveSpriteAndDestroy = SKAction.sequence([moveSkySprite, SKAction.removeFromParent()])
        
        for i in 0...2 {
            let backgroundPiece = SKSpriteNode(texture:((i%2==1) ? backTex : backTex2))
            
            //backgroundNode!.size.height = self.frame.size.height
            backgroundPiece.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            backgroundPiece.setScale(scaleValue)
            backgroundPiece.position = CGPoint(x: self.frame.size.width / 2.0, y: CGFloat(i) * (backTex2.size().height * scaleValue))
            backgroundPiece.zPosition = CGFloat(zIndex)
            backgroundPiece.runAction(moveSkySpritesForever)
            
            backgroundNode.addChild(backgroundPiece)
            
        }
        
        addChild(backgroundNode)
    }

    
   /* override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
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
    }*/
    
    func getRandomValue () -> CGPoint{
        let randomX = arc4random_uniform(446)+175
        // y coordinate between MinY (top) and MidY (middle):
        // let randomY = arc4random_uniform(UInt32(self.view!.frame.height))
        
        return CGPointMake(CGFloat(randomX), 1024 + holeTexture!.size().height/2.0)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if lastSpawn == 0 {
            lastSpawn = currentTime
        }
        
        if currentTime > lastSpawn + 1 {
            
            let sprite = SKSpriteNode(texture: holeTexture)
            
            sprite.xScale = 0.75
            sprite.yScale = 0.75
            sprite.position = getRandomValue()
            sprite.runAction(moveSpriteAndDestroy)
            
            self.addChild(sprite)
            lastSpawn = currentTime
        }
    }
    
    
    
}