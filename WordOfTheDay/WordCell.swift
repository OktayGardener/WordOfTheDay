//
//  WordCell.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 17/02/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import UIKit
import TwitterKit

class WordCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var definitionTextField: UITextView!
    @IBOutlet var descriptionTextField: UITextView!
    
    @IBOutlet var linkButton: UIButton!
    @IBOutlet var shareOnTwitterButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    
    var urbanDictionarylink: NSURL!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
