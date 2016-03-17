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
import TwitterKit

class WordOfTheDayViewController: UITableViewController {
    let urbanDictionaryRandomWordEndPoint: String = "http://api.urbandictionary.com/v0/random"
    var randomWordJSON: JSON!
    
    var words: [SlangWord] = []
    let wordTableCellReuseIdentifier = "WordCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presentLoginSuccessfulAlert()
        
        getWords() { responseObject, error in
            // use responseObject and error here
         //   print("responseObject = \(responseObject); error = \(error)")
            if responseObject != nil {
                self.randomWordJSON = JSON(responseObject!)
                self.parseRandomSlangWordOfTheDay(self.randomWordJSON)
                self.tableView.reloadData()
            } else {
                self.presentAlert("Network/API error", alertMessage: "Could not fetch the words, check your internet connection and try again", dismissMessage: "OK")
            }
            return
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.translucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Alerts
    func presentLoginSuccessfulAlert() {
        let alertController = UIAlertController(title: "Twitter login", message: "Great, you're authenticated with Twitter! Start by checking the words of the day!", preferredStyle: .Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func presentAlert(alertTitle: String, alertMessage: String, dismissMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: dismissMessage, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: JSON
    
    func getWords(completionHandler: (NSDictionary?, NSError?) -> ()) {
        retrieveJSON(self.urbanDictionaryRandomWordEndPoint, completionHandler: completionHandler)
    }
    
    func retrieveJSON(url: String, completionHandler: (NSDictionary?, NSError?) -> ()) {
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.randomWordJSON = JSON(value)
                    completionHandler(value as? NSDictionary, nil)
                }
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func parseRandomSlangWordOfTheDay(json: JSON){
        for i in 0...3 {
            if json["list"][i] != nil {
                let currentJSON = json["list"][i]
                let currentWord = SlangWord(
                    id: currentJSON["defid"].int!,
                    udpermalink: currentJSON["permalink"].string!,
                    word: currentJSON["word"].string!,
                    definition: currentJSON["definition"].string!,
                    description: currentJSON["example"].string!)
                self.words.append(currentWord)
            }
        }
    }

    // MARK: Cell Button Actions
    @IBAction func openUrbanDictionaryLink(sender: UIButton!) {
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if indexPath != nil {
            let current = self.words[indexPath!.row]
            UIApplication.sharedApplication().openURL(NSURL(string: current.udpermalink)!)
        }
    }
    
    @IBAction func shareOnTwitter(sender: AnyObject) {
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if indexPath != nil {
            let current = self.words[indexPath!.row]
            let composer = TWTRComposer()
            composer.setText("I just found out the meaning of \(current.word)!) via WOTD app! Check it out - github.com/oktaygardener")
            
            composer.setImage(UIImage(named: "fabric"))
            
            // Called from a UIViewController
            composer.showFromViewController(self) { result in
                if (result == TWTRComposerResult.Cancelled) {
                    print("Tweet composition cancelled")
                }
                else {
                    print("Sending tweet!")
                }
            }
        }

    }
    
    @IBAction func saveFavoriteWord(sender: AnyObject) {
        print("savefavoriteword called")
    }
    
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.words.count
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.width * 1.10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WordCell", forIndexPath: indexPath) as! WordCell
        let current = self.words[indexPath.row]
        cell.wordLabel.text = current.word
        cell.definitionTextField.text = current.definition
        cell.descriptionTextField.text = current.description
        cell.urbanDictionarylink = NSURL(string: current.udpermalink)
        
        
        // Actions for buttons
        cell.linkButton.addTarget(self, action: "openUrbanDictionaryLink:", forControlEvents: .TouchUpInside)
        cell.shareOnTwitterButton.addTarget(self, action: "shareOnTwitter:", forControlEvents: .TouchUpInside)
        cell.favoriteButton.addTarget(self, action: "saveFavoriteWord:", forControlEvents: .TouchUpInside)
        
        return cell
    }

    
    
}

