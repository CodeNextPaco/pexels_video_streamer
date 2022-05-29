//
//  ViewController.swift
//  videoTestApp
//
//
// Looper example
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    //AVPlayerLooper is used instead of AVPlayer
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    var playStopBtn = UIButton(type: .system)
    
    var isPlaying = false
    var player = AVPlayer(playerItem: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        
        //sample URL from Pexler API call
        
        let urlString = String("https://player.vimeo.com/external/342571552.sd.mp4?s=e0df43853c25598dfd0ec4d3f413bce1e002deef&profile_id=165&oauth2_token_id=57447761")
        
        let videoURL: NSURL =  NSURL.init(string: urlString)!
        
       let asset: AVAsset = AVAsset.init(url: videoURL as URL)
        
        let playerItem = AVPlayerItem(asset: asset)
        
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        
        self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        
        //object to render player to view: AVPlayerLayer -- gets instatiated with a player
        let playerLayer = AVPlayerLayer(player: queuePlayer)
        
        //set the player frame to fit the whole screen
         playerLayer.frame = view.bounds
        
        // optional videoGravity fills screen without distorting the aspect ration
        playerLayer.videoGravity = .resizeAspectFill
        
        //as as a sublayer
        view.layer.addSublayer(playerLayer)
        
        //playStopBtn.setTitle("Stop", for: .normal)
        self.playStopBtn.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
       
        self.playStopBtn.layer.cornerRadius = 48
        self.playStopBtn.clipsToBounds = true
        
         
        self.playStopBtn.center = view.center
        self.playStopBtn.frame = CGRect(x: view.center.x-50, y: view.frame.height - 180, width: 100, height: 100)
        view.addSubview(playStopBtn)
        
        self.playStopBtn.addAction(UIAction(handler: { _ in
            
            if self.isPlaying{
                self.isPlaying = false
                self.queuePlayer.pause()
                self.playStopBtn.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
                
            } else {
                self.isPlaying = true
                self.queuePlayer.play()
                self.playStopBtn.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
                
            }
            print("Toggle Play: " + String(self.isPlaying))
            
        }), for: .touchUpInside)
        
    }
    
}

