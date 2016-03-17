//
//  AboutViewController.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 16/03/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    static let sharedInstance = AboutViewController()
    
    @IBOutlet var avatarImageView: UIImageView! = UIImageView()
    @IBOutlet var githubButton: UIButton! = UIButton()
    @IBOutlet var twitterButton: UIButton! = UIButton()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }
    
    @IBAction func presentTwitterLink(sender: UIButton!) {
        print("yas twitter")
        if let requestUrl = NSURL(string: "http://twitter.com/oktaygardener") {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
    @IBAction func presentGithubLink(sender: UIButton!) {
        print("yas github")
        if let requestUrl = NSURL(string: "http://github.com/oktaygardener") {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
}