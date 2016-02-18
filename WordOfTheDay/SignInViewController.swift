//
//  SignInViewController.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 01/02/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//


import UIKit
import TwitterKit
import DigitsKit
import Crashlytics

class SignInViewController: UIViewController, UIAlertViewDelegate {
    // MARK: Properties
    
    @IBOutlet weak var logoView: UIImageView!
    
    @IBOutlet weak var signInTwitterButton: UIButton!
    
    @IBOutlet weak var signInPhoneButton: UIButton!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decorateButton(signInTwitterButton, color: UIColor(red: 0.333, green: 0.675, blue: 0.933, alpha: 1))
    }
    
    private func navigateToMainAppScreen() {
        performSegueWithIdentifier("ShowThemeChooser", sender: self)
    }
    
    // MARK: IBActions
    
    @IBAction func signInWithTwitter(sender: UIButton) {
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if session != nil {
                // Navigate to the main app screen to select a theme.
                self.navigateToMainAppScreen()
                
                // Tie crashes to a Twitter user ID and username in Crashlytics.
                Crashlytics.sharedInstance().setUserIdentifier(session!.userID)
                Crashlytics.sharedInstance().setUserName(session!.userName)
                
                // Log Answers Custom Event.
                Answers.logLoginWithMethod("Twitter", success: true, customAttributes: ["User ID": session!.userID])
            } else {
                // Log Answers Custom Event.
                Answers.logLoginWithMethod("Twitter", success: false, customAttributes: ["Error": error!.localizedDescription])
            }
        }
    }
    
    @IBAction func signInWithPhone(sender: UIButton) {
        // Create a Digits appearance with Cannonball colors.
        let appearance = DGTAppearance()
        appearance.backgroundColor = UIColor.whiteColor()
        appearance.accentColor = UIColor.greenColor()
        
           }
    
    @IBAction func skipSignIn(sender: AnyObject) {
        // Log Answers Custom Event.
        Answers.logCustomEventWithName("Skipped Sign In", customAttributes: nil)
    }
    
    // MARK: Utilities
    
    private func decorateButton(button: UIButton, color: UIColor) {
        // Draw the border around a button.
        button.layer.masksToBounds = false
        button.layer.borderColor = color.CGColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 6
    }
    
}
