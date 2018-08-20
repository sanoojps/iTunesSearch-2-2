//
//  SearchResultsTableViewCell.swift
//  iTunesSearch
//
//  Created by Maddiee on 19/08/18.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    
    @IBOutlet var titleTextLabel:UILabel!
    @IBOutlet var subtitleTextLabel:UILabel!
    @IBOutlet var albumArtImageView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        /// Configure image view appearance
        Utils.ViewConfigurations.configure(view: self.albumArtImageView, withCornerRadius: 120/2)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(model: Results)
    {
        // assign basic views
        self.titleTextLabel?.text = model.trackName ?? "[song]"
        self.subtitleTextLabel?.text = model.artistName ?? "[artist]"
        
        //placeholder image
        let albumplaceholder:UIImage? = UIImage.init(named: "albumplaceholder")
        self.albumArtImageView?.image = albumplaceholder
        
        // fetch image frrm url
        self.fetchImage(model, andSetToImageview: self.albumArtImageView)
        
    }
}

//MARK:- Image Downlo helper methods
extension SearchResultsTableViewCell
{
    final func fetchImage(_ model: Results ,andSetToImageview imageView:UIImageView?)
    {
        guard let artworkUrl: String = model.artworkUrl100 ,
            let imageURL: URL = URL(string: artworkUrl) else
        {
            return
        }
        
        NetworkManager.shared.downloadImage(url: imageURL) { (image, originalURL, error) in
            if (model.artworkUrl100 == originalURL.absoluteString) {
                if image != nil
                {
                    imageView?.image = image
                    self.setNeedsLayout()
                }
            }
        }
    }
}
