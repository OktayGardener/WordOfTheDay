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
    var refreshFactor: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to load more",
            attributes:[ NSForegroundColorAttributeName: UIColor.whiteColor() ])
        
        self.tableView.scrollsToTop = true
        
        self.presentLoginSuccessfulAlert()
        
        getWords() { responseObject, error in
            if responseObject != nil {
                self.randomWordJSON = JSON(responseObject!)
                self.parseRandomSlangWordOfTheDay(self.randomWordJSON)
                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesInRange: range)
                self.tableView.reloadSections(sections, withRowAnimation: .Automatic)
            } else {
                self.presentAlert("Network/API error",
                    alertMessage: "Could not fetch the words, check your internet connection and try again",
                    dismissMessage: "OK")
            }
            return
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
      //  navigationController?.navigationBar.translucent = false
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
        for i in 0...4 {
            if json["list"][i] != nil {
                let currentJSON = json["list"][i]
                let currentWord = SlangWord(
                    id: currentJSON["defid"].int!,
                    udpermalink: currentJSON["permalink"].string!,
                    word: currentJSON["word"].string!,
                    definition: currentJSON["definition"].string!,
                    example: currentJSON["example"].string!)
                //self.words.append(currentWord)
                self.words.insert(currentWord, atIndex: 0)
                //self.refreshFactor += 1
            }
        }
    }
    
    // MARK: Refresh
    func refresh(sender:AnyObject)
    {
        getWords() { responseObject, error in
            // use responseObject and error here
            //   print("responseObject = \(responseObject); error = \(error)")
            if responseObject != nil {
              //  self.tableView.beginUpdates()
                //self.words.removeAll()
                self.randomWordJSON = JSON(responseObject!)
                self.parseRandomSlangWordOfTheDay(self.randomWordJSON)
               // self.tableView.endUpdates()
                self.tableView.reloadData()
            } else {
                self.presentAlert("Network/API error", alertMessage: "Could not fetch the words, check your internet connection and try again", dismissMessage: "OK")
            }
            return
        }
        //self.tableView.reloadData()
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesInRange: range)
        self.tableView.reloadSections(sections, withRowAnimation: .Automatic)
        self.refreshControl!.endRefreshing()
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
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if indexPath != nil {
            let current = self.words[indexPath!.row]
            current.date = NSDate()
            SlangWordPersistence.sharedInstance.persistWord(current)
            FavoriteWordsTableViewController.sharedInstance.tableView.reloadData()
            presentAlert("Success", alertMessage: "Word successfully saved in favorites", dismissMessage: "OK")
        }
    }
    
    @IBAction func shareWord(sender: AnyObject) {
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if indexPath != nil {
            let current = self.words[indexPath!.row]
                let activityViewController = UIActivityViewController(activityItems: ["OMG I totally found out the meaning of \(current.word) via this bomb app by oktaygardener!! + \n" + current.udpermalink as NSString], applicationActivities: nil)
                presentViewController(activityViewController, animated: true, completion: {})
            
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.words.count //* self.refreshFactor
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.width * 1.10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WordCell", forIndexPath: indexPath) as! WordCell
        let current = self.words[indexPath.row]
        cell.wordLabel.text = current.word
        cell.definitionTextField.text = current.definition
        cell.descriptionTextField.text = current.example
        cell.urbanDictionarylink = NSURL(string: current.udpermalink)
        
        
        // Actions for buttons
        cell.linkButton.addTarget(self, action: "openUrbanDictionaryLink:", forControlEvents: .TouchUpInside)
        cell.shareOnTwitterButton.addTarget(self, action: "shareOnTwitter:", forControlEvents: .TouchUpInside)
        cell.favoriteButton.addTarget(self, action: "saveFavoriteWord:", forControlEvents: .TouchUpInside)
        
        cell.shareButton.addTarget(self, action: "shareWord:", forControlEvents: .TouchUpInside)
        
        return cell
    }

    
    
}

