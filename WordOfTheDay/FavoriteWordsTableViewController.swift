//
//  FavoriteWordsTableViewController.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 17/03/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import UIKit
import TwitterKit
    
private let SingletonSharedInstance = FavoriteWordsTableViewController()

class FavoriteWordsTableViewController: UITableViewController {

    var words: [SlangWord] = []
    
    class var sharedInstance : FavoriteWordsTableViewController {
        return SingletonSharedInstance
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        words = SlangWordPersistence.sharedInstance.retrieveWords()
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.tintColor = UIColor.whiteColor()
        
        self.tableView.scrollsToTop = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Make sure the navigation bar is not translucent when scrolling the table view.
        navigationController?.navigationBar.translucent = false
        
        // Display a label on the background if there are no poems to display.
        let noWordsLabel = UILabel()
        noWordsLabel.text = "You have not saved any words yet."
        noWordsLabel.textAlignment = .Center
        noWordsLabel.textColor = UIColor.whiteColor()
        noWordsLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
        tableView.backgroundView = noWordsLabel
        tableView.backgroundView?.hidden = true
        tableView.backgroundView?.alpha = 0
        toggleNoPoemsLabel()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Setup
    private func toggleNoPoemsLabel() {
        if tableView.numberOfRowsInSection(0) == 0 {
            UIView.animateWithDuration(0.15) {
                self.tableView.backgroundView!.hidden = false
                self.tableView.backgroundView!.alpha = 1
            }
        } else {
            UIView.animateWithDuration(0.15,
                animations: {
                    self.tableView.backgroundView!.alpha = 0
                },
                completion: { finished in
                    self.tableView.backgroundView!.hidden = true
                }
            )
        }
    }
    
    // MARK: Actions
    
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

    
    @IBAction func removeFavoriteWord(sender: AnyObject) {
        let alert = UIAlertController(title: "Remove from favorites?", message: "Are you sure you want to remove this word from favorites?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:{_ in
            let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
            if indexPath != nil {
                let current = self.words[indexPath!.row]
                current.date = NSDate()
                SlangWordPersistence.sharedInstance.removeWord(current)
                dispatch_async(dispatch_get_main_queue()) {
                    self.words = SlangWordPersistence.sharedInstance.retrieveWords()
                    self.tableView.reloadData()
                }
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareWord(sender: AnyObject) {
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if indexPath != nil {
            let current = self.words[indexPath!.row]
            let activityViewController = UIActivityViewController(activityItems: ["OMG I totally found out the meaning of \(current.word) via this bomb app by oktaygardener!! \n" + current.udpermalink as NSString], applicationActivities: nil)
            presentViewController(activityViewController, animated: true, completion: {})
            
        }
    }

    // MARK: Refreshes
    func refresh(sender:AnyObject) {
        self.words.removeAll()
        self.words = SlangWordPersistence.sharedInstance.retrieveWords()
        self.tableView.reloadData()
        
        self.refreshControl!.endRefreshing()
    }

    // MARK: Sorting
//    func sortWordsByName() {
//        var tempWords = self.words
//        var wordsByName: [SlangWord]
//        for x in tempWords {
//            for y in tempWords {
//                if x.word
//            }
//        }
//    }
    
    // MARK: Alerts
    
    func presentAlert(alertTitle: String, alertMessage: String, dismissMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: dismissMessage, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return words.count
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
        cell.favoriteButton.addTarget(self, action: "removeFavoriteWord:", forControlEvents: .TouchUpInside)
        
        cell.shareButton.addTarget(self, action: "shareWord:", forControlEvents: .TouchUpInside)

        
        return cell
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
