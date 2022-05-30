//
//  SearchViewController.swift
//  videoTestApp
//
//  Created by admin on 5/29/22.
//

import UIKit
 


class SearchViewController: UIViewController {
    
    
    let manager = APIManager()
    var videosArray = APIManager().videos

    override func viewDidLoad()  {
        super.viewDidLoad()
        
        Task{
            
            self.videosArray = await self.manager.searchPexelVidsByTerm(term: "Nature")
            print(videosArray[0].videoFiles[1].link)
        }
       

        // Do any additional setup after loading the view.
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
