//
//  GameScene.swift
//  Subpressao
//
//  Created by André Rodrigues de Jesus on 5/21/15.
//  Copyright (c) 2015 André Rodrigues de Jesus. All rights reserved.
//

import SpriteKit
import UIKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum CollisionCategory:UInt32 {
        case None = 1
        case Water = 2
        case Hole = 4
        case Boundary = 8
    }
    
    // Motion manager para uso do Acelerometro
    let motionManager = CMMotionManager()
    
    // Posicao inicial da agua, vinda do arquivo SKS
    var waterStartPos:SKNode?
    
    // Node de liquido
    var liquidNode:LQKLiquidNode?
    
    // Node de limite circular
    var circularBoundary:SKNode?
    
    var moveSpriteAndDestroy: SKAction?
    var lastSpawn:CFTimeInterval = 0;
    var firstUpdate:CFTimeInterval = 0;
    
    var holeTexture:SKTexture?
    
    var score:Int = 0
    var scoreLabel:SKLabelNode?
    var highScore = HighScore()
    var recorde:Int = 0
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        configureAccelerometer()
        waterStartPos = self .childNodeWithName("WaterStartPos")
        scoreLabel = self.childNodeWithName("ScoreLabel") as! SKLabelNode!
        scoreLabel?.fontName = "CutOutJams2-Regular"
        
        createWater()
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(245, 0, 277, 924))
        self.physicsBody!.categoryBitMask = CollisionCategory.Boundary.rawValue
        self.physicsBody!.collisionBitMask = CollisionCategory.Water.rawValue
        self.physicsBody!.contactTestBitMask = CollisionCategory.None.rawValue
        
        circularBoundary = SKNode()
        circularBoundary?.position = waterStartPos!.position
        let circlePath:CGMutablePathRef!  = CGPathCreateMutable();
        CGPathAddArc(circlePath, nil, 0, 0, 70, 0, CGFloat(M_PI * 2), true);
        circularBoundary?.physicsBody = SKPhysicsBody(edgeLoopFromPath: circlePath)
        circularBoundary?.physicsBody!.pinned = true
        self.addChild(circularBoundary!)
        circularBoundary?.physicsBody!.categoryBitMask = CollisionCategory.Boundary.rawValue
        circularBoundary?.physicsBody!.collisionBitMask = CollisionCategory.Water.rawValue
        circularBoundary?.physicsBody!.contactTestBitMask = CollisionCategory.None.rawValue
        
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
        
        var moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite, resetSkySprite]))
        
        moveSpriteAndDestroy = SKAction.sequence([moveSkySprite, SKAction.removeFromParent()])
        
        for i in 0...3 {
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
    
    
    func configureAccelerometer() {
        self.physicsWorld.gravity = CGVectorMake(0 , 0);
        println(self.view!.frame)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.view!.frame)
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler:{
            accelerometerData, error in
            let acceleration = accelerometerData.acceleration;
            self.physicsWorld.gravity = CGVectorMake(CGFloat(acceleration.x * 9.8) , CGFloat(acceleration.y * 9.8));
        })
        
    }
    
    func createWater() {
        let width = 16;
        let density = 1;
        let blurRadius = 12;
        let radius = 8;
        
        /* Create a texturing strategy for the liquid -- built-in, or on your own */
        let solidEffect:LQKSolidColorEffect = LQKSolidColorEffect(color: UIColor(red: CGFloat(70/255.0), green: CGFloat(200/255.0), blue: CGFloat(240/255.0), alpha: 1), withIndex: CGFloat(1), withWidth: CGFloat(width))
        
        /* Create a liquid filter with the liquid texturing effect */
        let filter:LQKCILiquidFilter = LQKCILiquidFilter(blurRadius: CGFloat(blurRadius), withLiquidEffect: solidEffect)
        
        /* Create a liquid node with the liquid filter */
        liquidNode = LQKLiquidNode(blurRadius: blurRadius, withLiquidFilter: filter)
        
        /* Create a particle factory that can produce optimized particles of a given size */
        let liquidParticleFactory:LQKLiquidParticleFactory = LQKLiquidParticleFactory(radius: CGFloat(radius))
        
        for i in 0..<30 {
            /* Spawn a single bead of liquid */
            let particleNode:SKNode = liquidParticleFactory.createLiquidParticle()
            particleNode.position = getRandomPointInCircle(waterStartPos!.position, withRadius: 50)
            particleNode.physicsBody!.density = CGFloat(density)
            
            particleNode.physicsBody!.categoryBitMask = CollisionCategory.Water.rawValue
            particleNode.physicsBody!.collisionBitMask = CollisionCategory.Boundary.rawValue | CollisionCategory.Water.rawValue
            particleNode.physicsBody!.contactTestBitMask = CollisionCategory.Hole.rawValue
            
            /* Add the particle to the liquid so it will adopt its visual properties */
            liquidNode!.addChild(particleNode)
        }
        
        self.addChild(liquidNode!)
    }
    
    func placar(){
        
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue("Berlin", forKey: "userCity")
        //This code saves the value "Berlin" to a key named "userCity".
    
    }

    
    func getRandomPointInCircle(cCenter:(CGPoint), withRadius cRadius:(CGFloat)) -> CGPoint {
        
        let r:Float = Float(arc4random_uniform(UInt32(cRadius)))
        let angle:Float = Float(arc4random_uniform(UInt32(M_PI*628.0)))/314.0
        
        // Now use the equations above!
        let x = Float(cCenter.x) + r * cosf(angle);
        let y = Float(cCenter.y) + r * sinf(angle);
        
        return CGPointMake(CGFloat(x), CGFloat(y));
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
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
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        let averageWater = getWaterAveragePosition()
        circularBoundary?.position = averageWater
        
        if lastSpawn == 0 {
            firstUpdate = currentTime
            lastSpawn = currentTime
        }
        
        score = Int((currentTime - firstUpdate) * 10);
        scoreLabel?.text = "\(Double(score)/10.0) metros";
        
        if currentTime > lastSpawn + 1 {
            
            let sprite = SKSpriteNode(texture: holeTexture)
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 3)
            sprite.physicsBody!.affectedByGravity = false
            sprite.physicsBody!.dynamic = false
            
            sprite.physicsBody!.categoryBitMask = CollisionCategory.Hole.rawValue
            sprite.physicsBody!.collisionBitMask = CollisionCategory.None.rawValue
            sprite.physicsBody!.contactTestBitMask = CollisionCategory.Water.rawValue
            
            sprite.xScale = 0.75
            sprite.yScale = 0.75
            sprite.position = getRandomValue()
            sprite.runAction(moveSpriteAndDestroy)
            
            self.addChild(sprite)
            lastSpawn = currentTime
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == CollisionCategory.Water.rawValue && secondBody.categoryBitMask == CollisionCategory.Hole.rawValue {
            firstBody.node?.removeFromParent()

            if liquidNode!.children.count == 0 {
                
                var transition = SKTransition.pushWithDirection(SKTransitionDirection.Down, duration: 1.5)
                
                if let scene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene {
                    // Configure the view.
                    let skView = self.view as SKView!
                    skView.showsFPS = true
                    skView.showsNodeCount = true
                    
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    
                    //pass values to GameOverScene
                    
                    highScore.highScore = 0
                    SaveHighScore().ArchiveHighScore(highScore: highScore)
                    var retrievedHighScore = SaveHighScore().RetrieveHighScore() as! HighScore
                    
                    if score > retrievedHighScore.highScore {
                        retrievedHighScore.highScore = score
                    }
                    recorde = retrievedHighScore.highScore
                    
                    println(recorde)
                    scene.gameScene = self
                    scene.score = score
                    scene.highScore = recorde
                    
                    skView.presentScene(scene, transition:transition)
                }
                
            }
        }
    }
    
    func getWaterAveragePosition() -> CGPoint {
        var xSum:CGFloat = 0
        var ySum:CGFloat = 0
        for node in liquidNode!.children {
            xSum += node.position.x
            ySum += node.position.y
        }
        return CGPointMake(xSum/CGFloat(liquidNode!.children.count), ySum/CGFloat(liquidNode!.children.count))
    }
    
    func getRandomValue () -> CGPoint{
        let randomX = arc4random_uniform(277)+245
        // y coordinate between MinY (top) and MidY (middle):
        // let randomY = arc4random_uniform(UInt32(self.view!.frame.height))
        
        return CGPointMake(CGFloat(randomX), 1024 + holeTexture!.size().height/2.0)
    }
    
}