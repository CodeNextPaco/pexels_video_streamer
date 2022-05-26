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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        
        let videoURL: NSURL = Bundle.main.url(forResource: "video_1", withExtension: "mp4")! as NSURL
        
        let player = AVPlayer(url: videoURL as URL)
        
        //object to render player to view: AVPlayerLayer -- gets instatiated with a player
        let playerLayer = AVPlayerLayer(player: player)
        
        //set the player frame to fit the whole screen
        playerLayer.frame = view.bounds
        
        // optional videoGravity fills screen without distorting the aspect ration
        playerLayer.videoGravity = .resizeAspectFill
        
        //as as a sublayer
        view.layer.addSublayer(playerLayer)
        
        //begin playing
        player.play()
        
        
        
    }


}

