//
//  WordCell.swift
//  WordOfTheDay
//
//  Created by Oktay Gardener on 17/02/16.
//  Copyright © 2016 Oktay Gardener. All rights reserved.
//

import UIKit

class WordCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet private weak var wordLabel: UILabel!
    @IBOutlet private weak var definitionLabel: UILabel!
    @IBOutlet private weak var exampleLabel: UILabel!
    
    private var gradient: CAGradientLayer!
    
    override func awakeFromNib() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
