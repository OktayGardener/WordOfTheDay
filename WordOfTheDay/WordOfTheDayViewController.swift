//
//  WordOfTheDayViewController.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 01/02/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WordOfTheDayViewController: UITableViewController {
    private let wordOfTheDay = WordOfTheDay.sharedInstance
    let urbanDictionaryRandomWord: String = "http://api.urbandictionary.com/v0/random"
    let urbanDictionaryWordOfTheDay: String = "http://urban-word-of-the-day.herokuapp.com/"
    
    var words: [SlangWord] = []
    let wordTableCellReuseIdentifier = "WordCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Make sure the navigation bar is translucent.
        navigationController?.navigationBar.translucent = true
        parseRandomSlangWordOfTheDay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveJSON(url: String) -> JSON {
        var json: JSON = ""
        
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    json = JSON(value)
                    print("JSON: \(json)")
                }
            case .Failure(let error):
                print(error)
            }
        }
        return json
    }
    
    // TODO, only has 2 values... meh?
  //  func parseSlangWordOfTheDay() -> SlangWord {
        
  //  }
    
    func presentSlangWordOfTheDay() {
        
    }
    
    
    func parseRandomSlangWordOfTheDay(){
        let json: JSON = retrieveJSON(urbanDictionaryRandomWord)
        print(json["list"][0]["word"].stringValue)
        print(json["list"][0]["example"].stringValue)
        print("definition: %s ", json["list"][0]["definition"].stringValue)
//        return SlangWord(
//            id: json["list"][0]["defid"].intValue,
//            udpermalink: json["list"][0]["permalink"].stringValue,
//            word: json["list"][0]["word"].stringValue,
//            definition: json["list"][0]["definition"].stringValue,
//            description: json["list"][0]["example"].stringValue)
    }
    
    func presentRandomSlangWordOfTheDay() {
        
    }
    
    // TODO
  //  func parseWordOfTheDay() -> Word {
        
  //  }
    
    func presentWordOfTheDay() {
        
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return words.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(wordTableCellReuseIdentifier, forIndexPath: indexPath) as! WordCell
        
        // Find the corresponding theme.
    //    let currentWord = words[indexPath.row]
        
        // Configure the cell with the theme.
        // cell.wordLabel =
        
        
        // TODO DO THIS FIX CELL AND PRESENT IT!!!!!!!!
        
        // Return the theme cell.
        return cell
    }

    
    
}

