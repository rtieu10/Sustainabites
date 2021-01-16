//
//  FavoritesItemCell.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 11/30/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//

import Foundation
import UIKit

//@class: a class that holds the data members and functions for the the custom Favorites Item Cell 
class FavoritesItemCell:UITableViewCell{
    
    //outlet to the meal name in the custom favorites item cell
    @IBOutlet weak var favoriteMealName: UILabel!
    
    //outlet to the meal image in custom favorites item cell
    @IBOutlet weak var favoritesImageView: UIImageView!
    
    //a variable that is a URL session task that stores downloaded data in a temporary file
    var downloadTask: URLSessionDownloadTask?
    
    //@func: this function sets the state of the selected cell, and animate transitions between states
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //@func: this function prepares the reusable cell to be reused by the delegate
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    //@func: this function updates the interface of the app, by changing the label and image of the favoritesItem cell
    func updateUI(for result: RecipeData){
        favoriteMealName.text = result.title
        favoritesImageView.image = UIImage(named:"Placeholder")
        
        //force unnwrapping the image url
        if let url = URL(string: result.image!) {
          downloadTask = favoritesImageView.loadImage(url: url)
        }
    }
}
