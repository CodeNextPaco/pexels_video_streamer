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
import Parse

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var enterCommentView: UIView!
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var playPauseBtn: UIButton!
    
    
    let LEFT_OFFSET = 20;
    
    
    //AVPlayerLooper is used instead of AVPlayer
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    //var playStopBtn = UIButton(type: .system)
    //var saveBtn = UIButton(type: .system)
    var backgroundImage = UIImageView()
    var isPlaying = false
    var isShowingComments = false
    var player = AVPlayer(playerItem: nil)
    
    
    //video data
    var videoUser = String()
    var videoDuration = Int()
    var videoCategory = String()
    var videoID = Int()
    public var urlString = String()
    
    //for scrollview
    @IBOutlet weak var commentsLabel: UILabel!
    
    
    
    //var commentScrollView = UIScrollView()
    //var commentContentView = UIView()
    
   // var commentInputField = UITextField()
    //var commentPostBtn = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.commentField.layer.cornerRadius = 5
        self.commentField.layer.borderColor = UIColor.lightGray.cgColor
        self.commentField.layer.borderWidth = 1
        self.commentField.backgroundColor = UIColor(named: "Clear")
        
        self.enterCommentView.isHidden = true
        
        self.commentsLabel.isHidden = true
        
        
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
        view.layer.insertSublayer(playerLayer, at: 0)
      
      //playStopBtn.setTitle("Stop", for: .normal)
        
        
        self.addDataLabels()
        
       // self.setupScrollView()
       // self.addPlayButton()
        
       // self.addSaveAndShareBtns()
       // self.addCommentFieldandBtn()
        
        
        self.queuePlayer.play()
            
              
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
  
    }
    
//    func setupScrollView(){
//
//        //self.commentScrollView = UIScrollView.init(frame: CGRect(x: LEFT_OFFSET, y: 500, width: 300, height: 400))
//
//        self.commentScrollView.frame = CGRect(x: LEFT_OFFSET, y: 300, width: 320, height: 400)
//
//        self.commentScrollView.contentSize = CGSize(width: 500, height: 2300)
//        view.addSubview(self.commentScrollView)
//        self.commentScrollView.addSubview(self.commentContentView)
//
//        self.commentContentView.backgroundColor = UIColor(named: "Blue")
//        self.commentContentView.centerXAnchor.constraint(equalTo: self.commentScrollView.centerXAnchor).isActive = true
//        self.commentContentView.widthAnchor.constraint(equalTo: self.commentScrollView.widthAnchor).isActive = true
//        self.commentContentView.topAnchor.constraint(equalTo: self.commentScrollView.topAnchor).isActive = true
//        self.commentContentView.bottomAnchor.constraint(equalTo: self.commentScrollView.bottomAnchor).isActive = true
//
//
//        let commentlabel = UILabel(frame: CGRect(x: 0, y: 10, width: 200, height: 200))
//        commentlabel.numberOfLines = 0
//        commentlabel.text = " Awesome Video!"
//        commentlabel.textAlignment = .left
//
//
//        var newLine = commentlabel.text! + "\n LOL"
//        commentlabel.text = newLine
//
//        commentlabel.makeLabel()
//        self.commentContentView.addSubview(commentlabel)
//    }
//
//    func addComment(){
//
//
//    }
    
    @IBAction func playPauseVideo(_ sender: Any) {
   
        if self.isPlaying{
            self.isPlaying = false
            self.queuePlayer.pause()
            self.playPauseBtn.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
       
        } else {
            self.isPlaying = true
            self.queuePlayer.play()
            self.playPauseBtn.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
       
                   }
    
    }
    
    @IBAction func saveFavorite(_ sender: Any) {
        
        print("Save Button")
       //            let favoriteVideo = PFObject(className:"favorite_video")
       //            favoriteVideo["favorite_video_url"] = self.urlString
    }
    
    @IBAction func showEnterCommentView(_ sender: Any) {
    
        
        if isShowingComments{
            self.enterCommentView.isHidden = true
            
            self.commentsLabel.isHidden = true
            
            self.isShowingComments = false
            
        } else {
            self.enterCommentView.isHidden = false
            
            self.commentsLabel.isHidden = false
            
            self.isShowingComments = true
            
        }
    
    
    
    }
    
    
    @IBAction func postComment(_ sender: Any) {
        
        
        let newComment = self.commentField.text
        
        print("Post Comment: \(newComment)")
        
        self.self.commentsLabel.text = self.commentsLabel.text! + "\n"+newComment!
        
        self.commentField.text = ""
         
        
    }
    
    
    
    func addDataLabels(){

        
        self.userLabel.text = self.videoUser

        self.durationLabel.text =  String(videoDuration) + " sec"
    
        self.categoryLabel.text = "#" + self.videoCategory
    

    }
    
//    func addSaveAndShareBtns(){
//
//        self.saveBtn = UIButton.init(frame:  CGRect(x: LEFT_OFFSET, y: 210 , width: 40 , height: 40))
//
//        self.saveBtn.setBackgroundImage(UIImage(systemName: "heart.circle"), for: .normal)
//        self.view.addSubview(saveBtn)
//
//        self.saveBtn.addAction(UIAction(handler: { _ in
//
//            print("Save Button")
//            let favoriteVideo = PFObject(className:"favorite_video")
//            favoriteVideo["favorite_video_url"] = self.urlString
//
//            favoriteVideo.saveInBackground { (succeeded, error)  in
//                if (succeeded) {
//                    print("Saved successfully")
//                    self.saveBtn.isUserInteractionEnabled = false
//                } else {
//                    // There was a problem, check error.description
//                    print("Error: \(error?.localizedDescription)" )
//
//                }
//            }
//
//        }), for: .touchUpInside)
//
//
//        let shareBtn = UIButton.init(frame:  CGRect(x: LEFT_OFFSET, y:  260, width: 40 , height: 40))
//
//        shareBtn.setBackgroundImage(UIImage(systemName: "paperplane.circle"), for: .normal)
//        self.view.addSubview(shareBtn)
//
//    }
//
//    func addPlayButton(){
//
//
//        self.playStopBtn.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
//
//        self.playStopBtn.center = view.center
//        self.playStopBtn.frame = CGRect(x: view.center.x-50, y: view.frame.height - 180, width: 100, height: 100)
//        view.addSubview(playStopBtn)
//
//        self.playStopBtn.addAction(UIAction(handler: { _ in
//
//            if self.isPlaying{
//                self.isPlaying = false
//                self.queuePlayer.pause()
//                self.playStopBtn.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
//
//            } else {
//                self.isPlaying = true
//                self.queuePlayer.play()
//                self.playStopBtn.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
//
//            }
//            print("Toggle Play: " + String(self.isPlaying))
//
//        }), for: .touchUpInside)
//    }
//
//    func addCommentFieldandBtn(){
//
//        self.commentInputField.frame = CGRect(x: LEFT_OFFSET, y: Int(view.frame.height) - 80, width: 400, height: 100)
//
//        self.commentInputField.borderStyle = .roundedRect
//
//        view.addSubview(self.commentInputField)
//
//
//    }
    
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
