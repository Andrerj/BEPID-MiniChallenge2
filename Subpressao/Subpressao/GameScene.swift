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
    
<<<<<<< HEAD
    
    
=======
>>>>>>> 072fe2fc89b7751453045f898cfa21b88706c978
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
    var lastUpdate:CFTimeInterval = 0;
    
    var holeTexture:SKTexture?
    
    var score:Double = 0
    var scoreLabel:SKLabelNode?
    var recorde:Int = 0
    
    let WATER_COUNT = 30
    
    var moveAndDestroySprites = [SKSpriteNode]()
    var moveAndLoopSprites = [SKSpriteNode]()
    var musicSounds = MusicSounds ()
    
    var pauseTeste = PauseScene ()
    
    var gamePaused:Bool = false
    var shouldUnpause:Bool = false
    var teste: SKSpriteNode?
    
    var pausePopup:SKNode = SKNode()
    var selectedNode:SKNode = SKNode()
    
    var pausaMusica:Bool = false
    
    override func didMoveToView(view: SKView) {
        
<<<<<<< HEAD
        
        
=======
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ("pauseGame") , name: UIApplicationDidEnterBackgroundNotification, object: nil)
       
>>>>>>> 072fe2fc89b7751453045f898cfa21b88706c978
        //toca musica
        
        musicSounds.playMusic("1-08 Puzzles")
        
<<<<<<< HEAD
        
        
        
=======
       
>>>>>>> 072fe2fc89b7751453045f898cfa21b88706c978
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
        
        self.addChild(pausePopup)
        
        
<<<<<<< HEAD
    }
    
=======
  
    }
>>>>>>> 072fe2fc89b7751453045f898cfa21b88706c978
    
    
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
            backgroundPiece.zPosition = CGFloat(zIndex) //TODO: validar se este zIndex esta sobrepondo as imagens
            backgroundPiece.runAction(moveSkySpritesForever)
            moveAndLoopSprites.append(backgroundPiece)
            
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
        
        for i in 0..<WATER_COUNT {
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
    
    
    
    func getRandomPointInCircle(cCenter:(CGPoint), withRadius cRadius:(CGFloat)) -> CGPoint {
        
        let r:Float = Float(arc4random_uniform(UInt32(cRadius)))
        let angle:Float = Float(arc4random_uniform(UInt32(M_PI*628.0)))/314.0
        
        // Now use the equations above!
        let x = Float(cCenter.x) + r * cosf(angle);
        let y = Float(cCenter.y) + r * sinf(angle);
        
        return CGPointMake(CGFloat(x), CGFloat(y));
    }
    
<<<<<<< HEAD
    
    
=======
>>>>>>> 072fe2fc89b7751453045f898cfa21b88706c978
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        var touch: UITouch = touches.first as! UITouch
        var location = touch.locationInNode(self)
        for node in self.nodesAtPoint(location) as! [SKNode] {
            
            if (node.name == nil) {
                continue
            }
            
            if (node.name == "musica_on_bt") {
                self.selectedNode = node
            }
            
            // If previous button is touched, start transition to previous scene
            let start:String.Index = node.name!.startIndex
            let end:String.Index = advance(node.name!.startIndex, 4)
            
            //println(node.name?[start...end])
            
            if node.name?[start...end] == "botao" {
                self.selectedNode = node
                self.selectedNode.hidden = true
            }
            //            if (node.name == "botao_tela_2_pause") {
            //                teste = self.childNodeWithName("botao_tela_2_pause") as! SKSpriteNode!
            ////                println(teste?.name)
            //                //troca imagem
            //                if(gamePaused == false){
            //                    teste?.hidden = true
            //
            //                }
            //                            else {
            //                                teste?.hidden = false
            //
            //                            }
            //
            //            }
            
    
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        var touch: UITouch = touches.first as! UITouch
        var location = touch.locationInNode(self)
        
<<<<<<< HEAD
        println(self.selectedNode.name)
=======
        if (node.name == "tela_2_pause") {
            teste = self.childNodeWithName("tela_2_pause") as! SKSpriteNode!
            

            //pausa jogo
            if(gamePaused == false){
                
                pauseGame()
                
                
            }
//            else {
//                
//                pauseGame(gamePaused)
//            }
        }
>>>>>>> 072fe2fc89b7751453045f898cfa21b88706c978
        
        self.selectedNode.hidden = false
        
        for anyNode in self.nodesAtPoint(location) {
            
            let node = anyNode as! SKNode
            
            
            if (node.name == nil) {
                continue
            }
            
            if node == selectedNode {
                
                if (node.name == "musica_on_bt") {
                    
                    //troca imagem
                   
                    if (pausaMusica == false){
                        node.hidden = true
                        pausaMusica = true
                        musicSounds.audioPlayer.stop()
                        
                    }
                    else {
                        node.hidden = false
                        pausaMusica = false
                        musicSounds.audioPlayer.play()
                    }
                }
                
                if (node.name == "botao_tela_2_pause") {
                    teste = self.childNodeWithName("botao_tela_2_pause") as! SKSpriteNode!
                    
                    
                    //pausa jogo
                    if(gamePaused == false){
                        
                        pauseGame()
                        
                        for child in (SKScene.unarchiveFromFile("PauseScene"))!.children {
                            
                            pausePopup.addChild((child.copy()) as! SKNode)
                        }
                        
                        
                    }
                    //            else {
                    //
                    //                pauseGame(gamePaused)
                    //            }
                }
                
                if (node.name == "botao_reiniciar_select") {
                    //Reiniciar = self.childNodeWithName("botao_reiniciar_select") as! SKSpriteNode!
                    //            println(Reiniciar?.name)
                    //troca imagem
                    
                    //Reiniciar?.hidden = false
                    
                    musicSounds.audioPlayer.stop()
                    
                    
                    
                    // var transition = SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: 1.5)
                    var transition = SKTransition.fadeWithDuration(1.5)
                    
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
                
                
                
                //        for node in moveAndLoopSprites {
                //            node.runAction(SKAction.speedTo(CGFloat(CGFloat(2) - CGFloat(liquidNode!.children.count)/CGFloat(self.WATER_COUNT)), duration: 0))
                //        }
                //
                if (node.name == "botao_continuar_select") {

                    pauseGame()
                    
                    for child in pausePopup.children {
                        
                        
                        child.removeFromParent()
                        teste?.hidden = false
                        
                    }
                }
            }
        }
        self.selectedNode = SKNode()
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        if (!gamePaused){
            /* Called before each frame is rendered */
            
            let averageWater = getWaterAveragePosition()
            circularBoundary?.position = averageWater
            
            if lastSpawn == 0 {
                lastUpdate = currentTime
                lastSpawn = currentTime
                scoreLabel?.text = "0.0 metros";
                return;
            }
            
            score += (currentTime - lastUpdate) * 10;
            scoreLabel?.text = "\(Double(Int(score))/10.0) metros";
            
            if Float(currentTime) > Float(lastSpawn) + 1.0 - (1.0 - (Float(liquidNode!.children.count)/Float(self.WATER_COUNT)))/2.0 {
                
                //println(self.holeTexture)
                
                let sprite = SKSpriteNode(texture: SKTexture(imageNamed:"hole"))
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 3)
                sprite.physicsBody!.affectedByGravity = false
                sprite.physicsBody!.dynamic = false
                
                sprite.physicsBody!.categoryBitMask = CollisionCategory.Hole.rawValue
                sprite.physicsBody!.collisionBitMask = CollisionCategory.None.rawValue
                sprite.physicsBody!.contactTestBitMask = CollisionCategory.Water.rawValue
                
                sprite.xScale = 0.75
                sprite.yScale = 0.75
<<<<<<< HEAD
                sprite.zPosition++ //TODO: confirmar se é necessário somar no zPosition
=======
                sprite.zPosition = 1
>>>>>>> 072fe2fc89b7751453045f898cfa21b88706c978
                sprite.position = getRandomValue()
                sprite.runAction(moveSpriteAndDestroy)
                moveAndDestroySprites.append(sprite)
                
                self.addChild(sprite)
                lastSpawn = currentTime
            }
            
            for node in moveAndLoopSprites {
                node.runAction(SKAction.speedTo(CGFloat(CGFloat(2) - CGFloat(liquidNode!.children.count)/CGFloat(self.WATER_COUNT)), duration: 0))
            }
            
            for node in moveAndDestroySprites {
                node.runAction(SKAction.speedTo(CGFloat(CGFloat(2) - CGFloat(liquidNode!.children.count)/CGFloat(self.WATER_COUNT)), duration: 0))
            }
            
        }
        if shouldUnpause {
            gamePaused = false
            shouldUnpause = false
            lastSpawn = currentTime
            lastUpdate = currentTime
            
        }
        
        lastUpdate = currentTime
        
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
            
            let soundfile = SKAction.playSoundFileNamed("bubble.mp3", waitForCompletion: true)
            
            runAction(soundfile)
            
            if liquidNode!.children.count == 0 {
                
                musicSounds.audioPlayer.stop()
                
                
                var transition = SKTransition.pushWithDirection(SKTransitionDirection.Down, duration: 1.5)
                
                if let scene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene {
                    // Configure the view.
                    let skView = self.view as SKView!
                    
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    
                    //pass values to GameOverScene
                    
                    var highScore = SaveHighScore().RetrieveHighScore() as! HighScore
                    
                    println("Score salvo: \(highScore.highScore)")
                    
                    if Int(score) > highScore.highScore {
                        highScore.highScore = Int(score)
                        SaveHighScore().ArchiveHighScore(highScore: highScore)
                        highScore = SaveHighScore().RetrieveHighScore() as! HighScore
                        highScore.highScore = Int(score)
                        
                    }
                    recorde = highScore.highScore
                    
                    println(recorde)
                    scene.gameScene = self
                    scene.score = Int(score)
                    scene.highScore = recorde
                    
                    skView.presentScene(scene, transition:transition)
                }
                
            }
        }
    }
    
    func pauseGame()
    {
        
        if(!gamePaused){
            
            for child in (SKScene.unarchiveFromFile("PauseScene"))!.children {
                
                pausePopup.addChild((child.copy()) as! SKNode)
            }
            
            self.scene!.runAction(SKAction.speedTo(0, duration: 0))
            
            gamePaused = true
            for child in liquidNode!.children {
                (child as! SKNode).physicsBody!.dynamic = false
            }
            
            
        }
            
        else if(gamePaused){
            
            self.scene!.runAction(SKAction.speedTo(1, duration: 0))
            shouldUnpause = true
            for child in liquidNode!.children {
                (child as! SKNode).physicsBody!.dynamic = true
            }
            
        }
        
        //return gamePaused
        
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