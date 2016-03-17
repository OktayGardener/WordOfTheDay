//
//  SettingsCell.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 16/03/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}