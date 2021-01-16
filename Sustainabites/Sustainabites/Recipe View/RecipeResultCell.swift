//
//  RecipeResultCell.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 11/18/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//

import UIKit
import AVFoundation

//@protocol: this protocol defines a method that is called whenever the favorite Button is tapped
protocol RecipeResultCellDelegate: AnyObject{
    func favoriteButtonTapped(name:String, image:String, button: UIButton, id: Int)
}

//@class: a class that holds the data members and functions for the the custom Recipe Results Cell
class RecipeResultCell:UITableViewCell{
    
    weak var delegate: RecipeResultCellDelegate?
    
    //outlet to the label in the Recipe Result custom cell
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    //outlet to the image in the Recipe Result custom cell
    @IBOutlet weak var recipeImageView: UIImageView!
    
    //outlet to the heart button in the Recipe Result custom cell
    @IBOutlet weak var favoriteButton: UIButton!
    
    //LOCAL VARIABLES
    var recipeName: String = ""  //local instance of recipeName
    var imageUrl: String = ""    //local instance of image url
    var likeButton: UIButton?    //local instance of likeButton
    var recipe_id: Int = 0       //local instance of recipe id
    
    //a variable that is a URL session task that stores downloaded data in a temporary file
    var downloadTask: URLSessionDownloadTask?
    
    //an audio player that allows for audio playback from a file
    var audioPlayer: AVAudioPlayer?
    
    
    //@func: this function saves a local instance of the information in the cell of the Recipe table view that the user taps on
    func saveName(name:String, image:String, button: UIButton, id: Int){
        self.recipeName = name
        self.imageUrl = image
        self.likeButton = button
        self.recipe_id = id
    } 
    
    
    //@func: this function is called each time the favorite button is tapped, and it plays the audio if a user is favoriting a recipe, this recipe also prompts the call of the favoriteButtonTapped function in the RecipeViewConntroller class
    @IBAction func tapFavorite(){

        let sound = Bundle.main.path(forResource: "ding.mp3", ofType: nil)!
        let urlString = URL(fileURLWithPath: sound)
        if favoriteButton.currentImage == UIImage(systemName:"heart"){
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: urlString)
                audioPlayer?.play()
            }
            catch{
                print("Could not play audio")
            }
        }
        else{
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: urlString)
                audioPlayer?.stop()
            }
            catch{
                print("Could not stop audio")
            }
        }
        

        //when the favorite button is tapped, we call the function on the delegate, and delegate the call to the view controller, pass local variables to the function 
        delegate?.favoriteButtonTapped(name: recipeName, image: imageUrl, button: likeButton!, id: recipe_id)
    }
    
    //@func: this function prepares the reusable cell to be reused by the delegate
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil 
    }
    

    //@func: this function sets the state of the selected cell, and animate transitions between states
     override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)

     }
    
    
    //@func: this function updates the label and image of the custom cell with the information gathered from the API  call 
    func updateUI(for result: RecipeResult){
        recipeNameLabel.text = result.title
        recipeImageView.image = UIImage(named:"Placeholder")
        
        //force unwrapping the image url
        if let url = URL(string: result.image!) {
          downloadTask = recipeImageView.loadImage(url: url)
        }
    }
    
}
