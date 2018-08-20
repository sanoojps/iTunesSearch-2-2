//
//  DetailsTableViewCell.swift
//  iTunesSearch
//
//  Created by Maddiee on 19/08/18.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet var titleTextLabel:UILabel!
    @IBOutlet var subtitleTextLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model: DetailsViewModel) {
        self.titleTextLabel?.text = model.key
        self.subtitleTextLabel?.text = model.value
    }

}
