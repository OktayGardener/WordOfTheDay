//
//  SlangWord.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 01/02/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import Foundation

class SlangWord {
    let id: Int
    let udpermalink: String
    let word: String
    let definition: String
    let description: String
    let date: NSDate?
    let urbanDictionaryRandomWord: String = "http://api.urbandictionary.com/v0/random"
    let urbanDictionaryWordOfTheDay: String = "http://urban-word-of-the-day.herokuapp.com/"
    
    
    init(id: Int, udpermalink: String, word: String, definition: String, description: String) {
        self.id = id
        self.udpermalink = udpermalink
        self.word = word
        self.definition = definition
        self.description = description
        self.date = NSDate()
    }
    
    init(dictionary: [String : AnyObject]) {
        // Note: This is a naive implementation of JSON parsing.
        // We might use Decodable: https://github.com/Anviking/Decodable
        
        id = dictionary["id"] as! Int
        udpermalink = dictionary["udpermalink"] as! String
        word = dictionary["word"] as! String
        definition = dictionary["definition"] as! String
        description = dictionary["description"] as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dictionary["sale_starts"] as! String
        date = dateFormatter.dateFromString(dateString)!
    }
    
    
    func jsonLoaded(json: String) {
        print("JSON: \(json)")
    }
    
    func jsonFailed(error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    
  //  func makeGet(endpoint:String) -> String {
//        let manager = AFHTTPRequestOperationManager()
//        manager.requestSerializer.setValue("608c6c08443c6d933576b90966b727358d0066b4", forHTTPHeaderField: "X-Auth-Token")
//        manager.GET(endpoint,
//            parameters: nil,
//            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
//                return responseObject.description
//            },
//            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
//                return error.localizedDescription
//            }
//        )
  //  }
}
