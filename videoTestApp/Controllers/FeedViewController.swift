//
//  FeedViewController.swift
//  videoTestApp
//
//  Created by admin on 6/10/22.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let manager = APIManager()
     
   
    @IBOutlet weak var tableView: UITableView!
    
    var videos = [PFObject]()
    var videoIDs = [Int]()
    var likedVideo = APIManager().video
    var videoFeed = [Video]()
    
     override func viewDidLoad()   {
        super.viewDidLoad()
        
        tableView.dataSource = self
         tableView.delegate  = self
        
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
                
                tableView.reloadData()
                
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for row... ")
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! VideoSearchCell
        
        
       // let videoURLString = videoImageURLS[indexPath.row].object(forKey: "liked_video_url")
        
        let videoURLString = videoFeed[indexPath.row].image
        
       // guard URL(string: videoURLString ) != nil else { return cell }
        
        guard let url = URL(string: videoURLString) else { return cell }
        
        print("URL *****> \(url)")
        
       cell.videoImage.loadurl(url: url)
        
        
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.videoFeed.count
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
