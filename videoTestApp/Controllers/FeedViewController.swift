//
//  FeedViewController.swift
//  videoTestApp
//
//  Created by admin on 6/10/22.
//

import UIKit
import Parse
import AVKit

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let manager = APIManager()
    var videos = [PFObject]()
    var videoIDs = [Int]()
    var likedVideo = APIManager().video
    var videoFeed = [Video]()
    

//    var playerLooper: AVPlayerLooper!
//    var queuePlayer: AVQueuePlayer!
    
    public var urlString = String() //each cell will need one 
    
     override func viewDidLoad()   {
        super.viewDidLoad()
        
         
         collectionView.delegate = self
         collectionView.dataSource = self
         //self.getLikedVideosFromParse()

        
        // Do any additional setup after loading the view.
    }
    
    
    
    func getLikedVideosFromParse(){

        let query = PFQuery(className: "LikedVideos")
        query.includeKey("user")
        
        query.limit = 20
        self.videoIDs = []
        query.findObjectsInBackground { (objects , error) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) rows.")
                // Do something with the found objects
                for object in objects {
                   
                    let id = object.object(forKey: "videoID")
                    
                    print(id!)
                   // print(object.object(forKey: "videoID") as Any)
                    
                    self.videoIDs.append(id as! Int)

                    
                }
                self.fetchData()
            }
            print(self.videoIDs)
            
           
        }
    }
    
    func fetchData()  {
        
       print("fetchData() called")
        Task{
            
            for video in self.videoIDs {
                
                self.likedVideo = await self.manager.getVideoById(id: video)
          
                
                self.videoFeed.append(likedVideo!)
                
                collectionView.reloadData()
                
            }

        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
       
        self.videoFeed = [] //remove all items
        print("ViewDidAppear")
        self.getLikedVideosFromParse()
        

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videoFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! FeedCell
        
        let videoURLString = videoFeed[indexPath.row].image
        
        guard let url = URL(string: videoURLString) else { return cell }
        
        cell.videoImageView.loadurl(url: url)
        

        return cell
    }
    

     
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare for Segue")
        let cell = sender as! FeedCell
        if let indexPath = collectionView.indexPath(for: cell){
            
            let videoPlayerVC = segue.destination as! PlayerViewController
            
            videoPlayerVC.urlString = videoFeed[indexPath.row].videoFiles[1].link
            videoPlayerVC.videoUser = videoFeed[indexPath.row].user.name
           // videoPlayerVC.videoCategory = self.searchTerm
            videoPlayerVC.videoDuration = videoFeed[indexPath.row].duration
            //videoPlayerVC.backgroundImage = cell.videoImage
            videoPlayerVC.videoID = videoFeed[indexPath.row].id
            
           // self.hidesBottomBarWhenPushed = true
            self.tabBarController?.tabBar.isHidden = true
            
        }
        
    }
     

}
