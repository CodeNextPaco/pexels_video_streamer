//
//  SearchViewController.swift
//  videoTestApp
//
//  Created by admin on 5/29/22.
//

import UIKit
 

class SearchViewController: UIViewController , UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let manager = APIManager()
    var videosArray = APIManager().videos
    var searchTerm = String()

    override func viewDidLoad()  {
        super.viewDidLoad()
        
        tableView.dataSource = self
        //tableView.delegate = self
        tableView.rowHeight = 550
        self.searchTerm = "Ocean"
        tableView.rowHeight = tableView.bounds.height
   
        self.fetchData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
     }
    
    
    func fetchData(){
        
        Task{
            
            self.videosArray = await self.manager.searchPexelVidsByTerm(term: self.searchTerm)
            tableView.reloadData()
 
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoSearchCell",
                                                 for: indexPath) as! VideoSearchCell
        
        
        let videoURLString = videosArray[indexPath.row].image
        
        guard let url = URL(string: videoURLString) else { return cell }
        
        cell.videoImage.loadurl(url: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return videosArray.count
    }
    
    
    @IBAction func searchForVideos(_ sender: Any) {
   
        
        if self.searchField.text != ""{
            
            self.searchTerm = self.searchField.text!
            
            self.fetchData()
        }
        
     }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Prepare for Segue")
        let cell = sender as! VideoSearchCell
        if let indexPath = tableView.indexPath(for: cell){
            
            let videoPlayerVC = segue.destination as! PlayerViewController
            
            videoPlayerVC.urlString = videosArray[indexPath.row].videoFiles[1].link
            videoPlayerVC.videoUser = videosArray[indexPath.row].user.name
            videoPlayerVC.videoCategory = self.searchTerm
            videoPlayerVC.videoDuration = videosArray[indexPath.row].duration
            videoPlayerVC.backgroundImage = cell.videoImage
            videoPlayerVC.videoID = videosArray[indexPath.row].id
            
           // self.hidesBottomBarWhenPushed = true
            self.tabBarController?.tabBar.isHidden = true
            
        }
 
    
    }

}

 
