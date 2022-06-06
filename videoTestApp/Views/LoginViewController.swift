//
//  LoginViewController.swift
//  videoTestApp
//
//  Created by admin on 6/6/22.
//

import UIKit
import AVKit

class LoginViewController: UIViewController {

    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let videoURL = Bundle.main.url(forResource:"cloudsvid", withExtension: "mp4")!
        let asset: AVAsset = AVAsset.init(url: videoURL as URL)
        let playerItem = AVPlayerItem(asset: asset)
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        self.queuePlayer.volume = 0
        self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        avPlayerLayer = AVPlayerLayer(player: queuePlayer)
        avPlayerLayer.videoGravity = .resizeAspectFill
        avPlayerLayer.frame = view.layer.bounds
         
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        self.queuePlayer.play()
         
         

//        avPlayer = AVPlayer(url: videoUrl!)
//        avPlayerLayer = AVPlayerLayer(player: avPlayer)
//        avPlayerLayer.videoGravity = .resizeAspectFill
//        avPlayer.volume = 0
//        avPlayer.actionAtItemEnd = .none
//
//        avPlayerLayer.frame = view.layer.bounds
//        view.backgroundColor = .clear
//        view.layer.insertSublayer(avPlayerLayer, at: 0)
//        avPlayer.play()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
