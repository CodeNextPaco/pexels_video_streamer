//
//  APIManager.swift
//  videoTestApp
//
//  Created by Paco on 5/29/22.
//  uses PEXELS api key
//

import Foundation


class APIManager: ObservableObject{
    
    
    //static private let apiKey = "563492ad6f91700001000001547b1c62398e455ca67fd4f0a706f6c4" // paste in Pexels Key(Token)
    
    static private let apiKey = "563492ad6f91700001000001da40add2e45a4cd9a0f6fe3bf82904bb"
    
    @Published private(set) var videos : [Video] = []
    @Published private(set) var video : Video!
    
    func searchPexelVidsByTerm(term: String) async -> [Video]{
        
        //async function that fetches video data from a term and decodes JSON response
        do {
            
           
            let auth = APIManager.apiKey
            
            //build our url string with a search term
            let baseUrl = "https://api.pexels.com/videos/search?query="
            
            let fetchUrlString = baseUrl + term + "&per_page=10&orientation=portrait"
            
            
           // make sure we have a url, so use a guard statement, else bail out
            guard let fetchUrl = URL(string: fetchUrlString) else { fatalError("Missing url")}
            
            
            var urlRequest = URLRequest(url: fetchUrl)
            
            //urlRequest.httpMethod = "GET"
            
            //set the header with the API key
            urlRequest.setValue(auth, forHTTPHeaderField: "Authorization")
            
            //async funxction return two values, data and response
           let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            //check if the response is working with a 200 status code
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                
                print((response as? HTTPURLResponse)?.statusCode)
                      
                fatalError("Could not fetch data")}
            
            let decoder = JSONDecoder()
            
            //set the decoder to handle snake case
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let decoderData = try decoder.decode(ResponseBody.self, from: data)

            self.videos = [] //empty it first, in case user has done another search
            self.videos = decoderData.videos

            
        } catch {
            
            print("Error fetching data from Pexels: \(error)")
            
        }
        
        return self.videos
    }
    
    func getVideoById(id: Int)  async -> Video{
        //async function returns a Pexels video from a given video ID
        
        do {
            
            let auth = APIManager.apiKey
            
            //build our url string with a search term
            let baseUrl = "https://api.pexels.com/videos/videos/"
            
            let fetchUrlString = baseUrl + String(id)
            
            print(fetchUrlString)
            
            // make sure we have a url, so use a guard statement, else bail out
            guard let fetchUrl = URL(string: fetchUrlString) else { fatalError("Missing url") }
            var urlRequest = URLRequest(url: fetchUrl)
            urlRequest.setValue(auth, forHTTPHeaderField: "Authorization")
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Could not fetch data")}
       
            let decoder = JSONDecoder()
            
            //set the decoder to handle snake_case
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let decoderData = try decoder.decode(Video.self, from: data)
            
             
            self.video = decoderData
        
            
        } catch {
            
            print("Error fetching data from Pexels: \(error)")
            
        }
        
        return self.video

    }
    
}

//Data model for the Response and a Video, we will use this to map the JSON data
struct ResponseBody: Decodable{
    
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Video]
}

// a Video that is returned will have basic info and then an array of video in different formats, also User info
struct Video: Decodable, Identifiable{
    
    var id: Int
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]
    
    struct User : Decodable, Identifiable{
        
        var id: Int
        var name: String
        var url: String
    }
    
    struct VideoFile: Decodable, Identifiable{
        
        var id: Int
        var quality: String
        var fileType: String
        var link: String
        
    }
    
}
