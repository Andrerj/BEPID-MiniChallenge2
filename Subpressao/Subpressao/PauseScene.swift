//
//  PauseScene.swift
//  Subpressao
//
//  Created by Kalim on 17/06/15.
//  Copyright (c) 2015 André Rodrigues de Jesus. All rights reserved.
//

import SpriteKit

var pause: SKSpriteNode?
var continuar: SKSpriteNode?
var Reiniciar: SKSpriteNode?



class PauseScene: SKScene {
    override func didMoveToView(view: SKView) {
       // musicSounds.playMusic("1-08 Puzzles")
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: UITouch = touches.first as! UITouch
        var location = touch.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        
        
        
        
//        if (node.name == "botao_musica_on") {
//            pause = self.childNodeWithName("botao_musica_on") as! SKSpriteNode!
//            println(pause?.name)
//            //troca imagem
//            if(pause?.hidden == false) {
//                pause?.hidden = true
//                musicSounds.audioPlayer.stop()
//
//            }
//            else {
//                pause?.hidden = false
//              //  musicSounds.audioPlayer.play()
//            }
//        }
        
        
        if (node.name == "botao_continuar_select") {
            continuar = self.childNodeWithName("botao_continuar_select") as! SKSpriteNode!
            println(continuar?.name)
            
            //troca imagem
            continuar?.hidden = true
        
        }
        if (node.name == "botao_reiniciar_select") {
            Reiniciar = self.childNodeWithName("botao_reiniciar_select") as! SKSpriteNode!
            println(Reiniciar?.name)
            //troca imagem
            
            Reiniciar?.hidden = true
            

            
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: UITouch = touches.first as! UITouch
        var location = touch.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        
        if (node.name == "botao_reiniciar_select") {
            Reiniciar = self.childNodeWithName("botao_reiniciar_select") as! SKSpriteNode!
            println(Reiniciar?.name)
            //troca imagem
            
           
            musicSounds.audioPlayer.stop()
            
            Reiniciar?.hidden = false
            
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
        
        if (node.name == "botao_continuar_select") {
            continuar = self.childNodeWithName("botao_continuar_select") as! SKSpriteNode!
            println(continuar?.name)
            
            //troca imagem
            continuar?.hidden = false
         
        }
        
        
        
        
    }
    
        func mudaBotao(bra: SKSpriteNode?, type: String) -> SKSpriteNode{
            
            var teste: SKSpriteNode?
            
            teste = bra
            
            
            teste? = self.childNodeWithName("type") as! SKSpriteNode!
            
            teste?.hidden = true
            
            
            
            return bra!
        }
        
        
        
    
}