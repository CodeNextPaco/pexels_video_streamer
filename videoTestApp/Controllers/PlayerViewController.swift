//
//  PlayerViewController.swift
//  videoTestApp
//
//
// Looper example
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    let LEFT_OFFSET = 20;
    public var urlString = String()
    //AVPlayerLooper is used instead of AVPlayer
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    var playStopBtn = UIButton(type: .system)
    var backgroundImage = UIImageView()
    var isPlaying = false
    var player = AVPlayer(playerItem: nil)
    
    
    //video data
    var videoUser = String()
    var videoDuration = Int()
    var videoCategory = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
       // self.backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        //self.backgroundImage.frame.size.width = 400
        //self.backgroundImage.frame.size.height = 400
        //self.backgroundImage.center.y = self.view.center.y - 100
        
      //  self.backgroundImage.frame = view.bounds
         
       // view.addSubview(self.backgroundImage)
        
        
        let videoURL: NSURL =  NSURL.init(string: self.urlString)!
      
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

        self.addPlayButton()
        self.addDataLabels()
        self.addSaveAndShareBtns()
            
              
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
  
    }
    
    func addDataLabels(){
        
        let userlabel = UILabel.init(frame: CGRect(x: LEFT_OFFSET, y:  100, width: 300, height: 40))
        userlabel.text = "Uploaded by : " + self.videoUser
 
        userlabel.makeLabel()
        self.view.addSubview(userlabel)
        
        let durationlabel =  UILabel.init(frame: CGRect(x: LEFT_OFFSET, y:  130, width: 300 , height: 40))
        durationlabel.text = "Duration : " + String(videoDuration) + " sec"
        self.view.addSubview(durationlabel)
        durationlabel.makeLabel()
        
        let categoryLabel = UILabel.init(frame: CGRect(x: LEFT_OFFSET, y:  160, width: 300, height: 40))
        categoryLabel.text = "Category : " + self.videoCategory
        self.view.addSubview(categoryLabel)
        categoryLabel.makeLabel()
        
    }
    
    func addSaveAndShareBtns(){
        
        let saveBtn = UIButton.init(frame:  CGRect(x: LEFT_OFFSET, y: 210 , width: 40 , height: 40))
        
        saveBtn.setBackgroundImage(UIImage(systemName: "heart.circle"), for: .normal)
        self.view.addSubview(saveBtn)
        
        let shareBtn = UIButton.init(frame:  CGRect(x: LEFT_OFFSET, y:  260, width: 40 , height: 40))
        
        shareBtn.setBackgroundImage(UIImage(systemName: "paperplane.circle"), for: .normal)
        self.view.addSubview(shareBtn)
        
    }
    
    func addPlayButton(){
        
        
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

extension UILabel {
    func makeLabel() {
        //configure appearance of labels here
        self.textAlignment = .left
        self.font = UIFont(name: "AvenirNextRegular", size:20.0)
        self.font = .systemFont(ofSize: 20)
        self.adjustsFontSizeToFitWidth = true
        self.textColor = UIColor(red: 1.0, green: 1.00, blue: 1.00, alpha: 0.90)
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2.4
        self.layer.shadowColor = CGColor.init(srgbRed: 10, green: 10, blue: 10, alpha: 0.6)
        
    }
}
