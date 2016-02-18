//
//  WordOfTheDayViewController.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 01/02/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import UIKit
import Alamofire

class WordOfTheDayViewController: UIViewController {
    private let wordOfTheDay = WordOfTheDay.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveJSON(url: String) {
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
//    func retrieveJSON(url: String) {
//        if let url = NSURL(string) {
//                    let session = NSURLSession.sharedSession()
//                    let download = session.dataTaskWithURL(url) {
//                        (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//                        
//                        // print(data)
//                        if let data = data {
//                            dispatch_async(dispatch_get_main_queue()) {
//                                self.parseJSONData(data)
//                            }
//                        }
//                    }
//                    
//                    download.resume()
//                }
//            }
    
    func parseSlangWordOfTheDay() -> SlangWord {
        
    }
    
    func presentSlangWordOfTheDay() {
        
    }
    
    
    func parseRandomSlangWordOfTheDay() -> SlangWord {
        
    }
    
    func presentRandomSlangWordOfTheDay() {
        
    }
    
    
    func parseWordOfTheDay() -> Word {
        
    }
    
    func presentWordOfTheDay() {
        
    }
    
    
    
}

