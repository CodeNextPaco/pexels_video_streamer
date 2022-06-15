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
    
    //needed to toggle comment view when keyboard show/hides
    var commentViewOriginY: CGFloat = 0.0;
    
    
    //AVPlayerLooper is used instead of AVPlayer
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    var backgroundImage = UIImageView()
    var isPlaying = false
    var isShowingComments = false
    
    
    //video data
    var videoUser = String()
    var videoDuration = Int()
    var videoCategory = String()
    var videoID = Int()
    public var urlString = String()
    var videoComments = [String]()
    
    //for scrollview
    @IBOutlet weak var commentsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //don't think we can set some of these items in storyboard
        self.commentField.layer.cornerRadius = 5
        self.commentField.layer.borderColor = UIColor.lightGray.cgColor
        self.commentField.layer.borderWidth = 1
        self.commentField.backgroundColor = UIColor(named: "Clear")
        self.enterCommentView.isHidden = true //initially hidden
        self.commentsLabel.isHidden = true
        
        //get the url for the video resource and load looping player
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
        view.layer.insertSublayer(playerLayer, at: 0)

        self.addDataLabels()
        
        //video will play automatically
        self.queuePlayer.play()
        
        //adding the notification observer to move the commentField up when keyboard present
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
              
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        //get the origin of the comments view so we can replace it when keyboard hides
        self.commentViewOriginY = self.enterCommentView.frame.origin.y
        
    }
  
    
    @IBAction func shareVideo(_ sender: Any) {
        //to share the video to other social media, etc.
        let itemToShare = [self.urlString]
        
        let activityViewController = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]

               // present the view controller
               self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func playPauseVideo(_ sender: Any) {
    //toggles the video playing, but no longer used as video plays automatically. Could be used if needed.
        
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
        //stores a video in Parse as a PFObject with keys
        
        //if className is not present, it creates it
        let likedVideo = PFObject(className: "LikedVideos")
        
        //associate user with a video
        likedVideo["user"] = PFUser.current()!
        likedVideo["liked_video_url"] = self.urlString
        likedVideo["category"] = self.videoCategory
        likedVideo["videoID"] = self.videoID
        
        //save object to Parse, which will handle everything
        likedVideo.saveInBackground { (succeeded, error)  in
                       if (succeeded) {
                           print("Saved successfully")
                          // self.vid.isUserInteractionEnabled = false
                       } else {
                           // There was a problem, check error.description
                           print("Error: \(error?.localizedDescription)" )
                       }
                   }
        
    }
    
    @IBAction func showEnterCommentView(_ sender: Any) {
    //toggle the comment view text field and comments scroll view
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

        self.commentsLabel.text = self.commentsLabel.text! + "\n"+newComment!
        
        self.commentField.text = ""
        
        let videoComment = PFObject(className: "Comments")
        
        videoComment["user"] = PFUser.current()!
        videoComment["VideoComment"] = newComment
        videoComment["videoId"] = self.videoID
        
        videoComment.saveInBackground { (succeeded, error)  in
                       if (succeeded) {
                           print("Saved successfully")
                          // self.vid.isUserInteractionEnabled = false
                       } else {
                           // There was a problem, check error.description
                           print("Error: \(String(describing: error?.localizedDescription))" )
       
                       }
                   }
    }
    
    func addDataLabels(){

        self.userLabel.text = self.videoUser
        self.durationLabel.text =  String(videoDuration) + " sec"
        self.categoryLabel.text = "#" + self.videoCategory
    
    }
  
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //to move the comment entery view, we need to get teh keybard size
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }

      // move the root view up by the distance of keyboard height
        self.enterCommentView.frame.origin.y = self.enterCommentView.frame.origin.y - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.enterCommentView.frame.origin.y = self.commentViewOriginY
    }
    

}

