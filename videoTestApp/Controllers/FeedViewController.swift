//
//  FeedViewController.swift
//  videoTestApp
//
//  Created by admin on 6/10/22.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let manager = APIManager()
    
    var videos = [PFObject]()
    var videoIDs = [Int]()
    var likedVideo = APIManager().video
    var videoFeed = [Video]()
    
     override func viewDidLoad()   {
        super.viewDidLoad()
        
    
         collectionView.delegate = self
         collectionView.dataSource = self
         //self.getLikedVideosFromParse()

        
        // Do any additional setup after loading the view.
    }
    
    func getLikedVideosFromParse(){
        
        
        let query = PFQuery(className: "LikedVideos")
        
        //let user = PFUser.current()
        
       // query.whereKey("user", equalTo: user?.objectId! as Any)
        
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
            
            //print("Saved videro image urls")
           // print(self.videoImageURLS)
            
          //  tableView.reloadData()
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
       
        self.videoFeed = [] //remove all items
        print("ViewDidAppear")
        self.getLikedVideosFromParse()
        
        //tableView.reloadData()
        
   
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
