//
//  LoginViewController.swift
//  videoTestApp
//
//  Created by admin on 6/6/22.
//

import UIKit
import AVKit
import Parse

class LoginViewController: UIViewController {

    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    
 
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
         
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        let user = PFUser()
        user.username = userTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
              let errorString = error.localizedDescription
              
               print(errorString)
                
            } else {
              // Hooray! Let them use the app now.
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
          }
        
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        
        let username = userTextField.text!
        let password = passwordTextField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password){
            
            (user: PFUser?, error: Error?) -> Void in
             if user != nil {
               // Do stuff after successful login.
                 self.performSegue(withIdentifier: "loginSegue", sender: nil)
                 
             } else {
               // The login failed. Check error to see why.
                 
                 print("Error loging in: \(String(describing: error?.localizedDescription))")
             }
        }
        
        
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
