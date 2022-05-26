//
//  ViewController.swift
//  videoTestApp
//
//  Created by admin on 5/25/22.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    var isPlaying = false
    var player = AVPlayer(playerItem: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        
        let videoURL: NSURL = Bundle.main.url(forResource: "video_2", withExtension: "mp4")! as NSURL
        
       // let player = AVPlayer(url: videoURL as URL)
        self.player.replaceCurrentItem(with: AVPlayerItem(url: videoURL as URL))
        
        //object to render player to view: AVPlayerLayer -- gets instatiated with a player
        let playerLayer = AVPlayerLayer(player: player)
        
        //set the player frame to fit the whole screen
        playerLayer.frame = view.bounds
        
        // optional videoGravity fills screen without distorting the aspect ration
        playerLayer.videoGravity = .resizeAspectFill
        
        //as as a sublayer
        view.layer.addSublayer(playerLayer)
        
        //begin playing
        //self.player.pause()
        
        
        //button does nothing yet, just practicing formatting it
        let playStopBtn = UIButton(type: .system)
        
       
        //playStopBtn.setTitle("Stop", for: .normal)
        playStopBtn.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
       
        playStopBtn.layer.cornerRadius = 48
        playStopBtn.clipsToBounds = true
        
         
        playStopBtn.center = view.center
        playStopBtn.frame = CGRect(x: view.center.x-50, y: view.frame.height - 180, width: 100, height: 100)
        view.addSubview(playStopBtn)
        
        
        playStopBtn.addAction(UIAction(handler: { _ in
            
            if self.isPlaying{
                self.isPlaying = false
                self.player.pause()
                
            } else {
                self.isPlaying = true
                self.player.play()
            }
            print("Toggle Play: " + String(self.isPlaying))
            
        }), for: .touchUpInside)
        
        
        
    }
    
 
}

