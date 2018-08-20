//
//  DetailsHeaderView.swift
//  iTunesSearch
//
//  Created by Maddiee on 19/08/18.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import UIKit

class DetailsHeaderView: UIView {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            Utils.ViewConfigurations.configure(
                view: imageView,
                withCornerRadius: imageView.frame.width / 2.0,
                borderWidth:0.0
            )
            
            let borderColor =
                UIColor(red: 25/255.0, green: 161/255.0, blue: 136.0 / 255.0, alpha: 1.0)
            
            Utils.ViewConfigurations.configure(
                view: borderView,
                withCornerRadius: borderView.frame.width / 2.0,
                borderWidth: 4.0,
                andColor: borderColor
            )
            
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
