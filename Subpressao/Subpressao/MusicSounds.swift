//
//  MusicSounds.swift
//  Subpressao
//
//  Created by Kalim on 15/06/15.
//  Copyright (c) 2015 André Rodrigues de Jesus. All rights reserved.
//

import Foundation
import AVFoundation

class MusicSounds {
    // AudioPlayer
    var audioPlayer = AVAudioPlayer()
    
    
    func playMusic(sound:String) -> Bool{
        var music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound, ofType: "mp3")!)
        // var music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound, ofType: "mp3")!)
         println(music)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: music, error: &error)
       // if set == "play" {
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            return audioPlayer.play()
        
        
    
    }
    
//    func playSoundMusic(sound:(String), set:(String)) -> Bool{
    
   // }
}
