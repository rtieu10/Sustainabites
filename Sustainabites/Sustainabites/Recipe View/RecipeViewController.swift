//
//  RecipeViewController.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 12/1/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//@VC: this view controller displays the recipes that result from the API call that was done with the user's selected ingredients
class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //outlet to the table view in the view controller
    @IBOutlet weak var tableView: UITableView!
    
    
    //a copy of the selectedIngredients array that was passed from MyFridge VC
    var ingredList:[String]!=[]
    
    
    //a variable that is a URL session task that stores downloaded data in a temporary file
    var dataTask: URLSessionDataTask?
    
    
    //a reference to the managed object context, allows to  retrive and save data in core data
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    
    
    //array of the items stored in Core Data
    var FavoriteRecipes = [RecipeData]()
    
    
    //the array of recipe results that will be displayed to the user
    var recipeResults = [RecipeResult]()
    
    //the id of the recipe the user taps on
    var selected_id = 0
    
    //@struct: a struct to reference the customized cell names
    struct TableView{
        struct CellIdentifiers{
            static let RecipeResultCell = "RecipeResultCell"
        }
    }
    
    //@func: function called when view is initially loaded, the custom table cells are registered, and populate the recipeResults array with data from the API call, and the FavoriteRecipes array with the data stored in CoreData
    override func viewDidLoad(){
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.RecipeResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.RecipeResultCell)
        
        //@dispatch: we use a dispatch in order to indicate that we must wait for the recipeResults array to be populated with information from the API call
        let dispatch = DispatchGroup()
        dispatch.enter() //any code that enters the dispatch needs to finish
        
        fetchData { (reciperesults) in
            for recipes in reciperesults{
                print(recipes.title)
            }
            self.recipeResults = reciperesults
            
            dispatch.leave()
        }
        
        do{
            self.FavoriteRecipes  =  try context.fetch(RecipeData.fetchRequest())
            for recipes in FavoriteRecipes{
                print(recipes.title)
            }
        }
        catch{
            print("Error printing favorite recipes")
            
        }
        
        
        //notify the main thread because it needs to be completed first, because UI updates need to be completed on main thread
        dispatch.notify(queue: .main){
            self.tableView.reloadData()
        }
        

    }
    
    //@func: this function is called everytime the view appears, and it consistently fetches data from CoreData
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchRecipes()
    }
    
    //@func: this function returns the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipeResults.count ==  0{
            return 0
        }
        return recipeResults.count
    }
    
    //@func: this function populates the table with the Recipe Result custom cell, and updates the label and images with the appropriate recipe name and image received from the API call, it is also responsible for returning cells with "filled" hearts if its in the favoriteRecipes list 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //variable checks if the cell is liked
        var liked  = false

        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.RecipeResultCell, for: indexPath) as! RecipeResultCell
        
        let recipeResult = recipeResults[indexPath.row]

        cell.saveName(name: recipeResult.title!, image: recipeResult.image!, button: cell.favoriteButton, id: recipeResult.id!) 
        cell.delegate = self
        cell.updateUI(for:recipeResult)
        

        for x in FavoriteRecipes{
            if x.title == recipeResult.title!{
                 liked =  true
            }
        }
        
        //if the recipe is in the favorites list, then we set its image to a  filled heart, if not then we just set it to a normal heart
        if liked{
            cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else{
            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for:.normal)
        }
        
        return cell
    }
    
    
    //@func: this function provides a deselection animation based on the row the user taps, it also sends the id of the selected meal to the instructions view controller for the instructions API call
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        let recipeResult = recipeResults[indexPath.row]
        selected_id = recipeResult.id! //set the selected id to the id of the ingredient
        print(selected_id)
        let Storyboard = UIStoryboard(name:"Main", bundle: nil)
        
        //set the destination of id to the Instructions VC, pass id to next view
        let vc = Storyboard.instantiateViewController(withIdentifier: "InstructionsViewController") as! InstructionsViewController
        vc.recipe_id = selected_id
        
        //segue to Instructions VC
        self.navigationController?.pushViewController(vc, animated: true)

    }

    
    //@func: this function tells the delegate if the row in the table is about to be selected
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      if recipeResults.count == 0 {
        return nil
      } else {
        return indexPath
      }
    }
    
    //@func: this function performs the API call, with the url we created from the helper function, and saves the data from the call into postsData 
    func fetchData(completionHandler: @escaping ([RecipeResult]) -> Void){
            
        let url = recipeURL(ingredientsList: ingredList)
            
        let session = URLSession.shared.dataTask(with: url){
            (data, response, error) in

            guard let data = data else{ return }

            do{
                //@postsData: the array of RecipeResult objects received from API call
                let postsData = try JSONDecoder().decode([RecipeResult].self, from:data)

                completionHandler(postsData)
            }
            catch{
                let error = error
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    
    //@func:this function takes in the array of strings that the user selected from the ingredients list, and adds it to the url, and returns the URL for API call
    func recipeURL(ingredientsList:[String]) ->  URL{
        var resultingIngredients = ""
        
        
        for ingredients in ingredientsList{
            resultingIngredients += ingredients+","
        }
        
        let APIKEY = Constants.SpoonacularApiKey
        let urlString = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=\(APIKEY)&ingredients=\(resultingIngredients)"
        
        let url = URL(string: urlString)
        
        return url!
        
    }
    
    
    //@func: this function retrieves the data that is currently stored in core data, and saves it in the FavoriteREcipes array 
    func fetchRecipes(){
        do{
            //passing in a request to grab RecipeData objects from CoreData
            self.FavoriteRecipes = try context.fetch(RecipeData.fetchRequest())
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        catch{
            print("Could not load recipes")
        }
    }
    
    
}

//@extension: the view controller conforms to the delegate and must implement the favoriteButtonTapped function
extension RecipeViewController: RecipeResultCellDelegate{
    
    
    //@func: this function checks whether the user is attempting to add or remove the recipe from the favorites list, and adds/removes the recipe from CoreData accordingly
    func favoriteButtonTapped(name: String, image: String, button: UIButton, id: Int) {
        
        //if the heart icon is empty, and user wants to add to favorites 
        if button.currentImage == UIImage(systemName: "heart"){
            let newRecipe = RecipeData(context: self.context)
            
            newRecipe.title = name
            newRecipe.image = image
            newRecipe.id = Int64(id)  //setting id to int64
            
            self.tableView.reloadData()
            
            print(name)
            print(image)
            print(id) 
            
            do{
                try self.context.save()
            }
            catch{
                print("Could not save  recipe")
            }
        }
        
        //if heart is filled, and user wants to remove from favorites
        else{
            for i in 0 ..< FavoriteRecipes.count{
                
                if FavoriteRecipes[i].title == name{
                    context.delete(FavoriteRecipes[i])
                }
            }
        }
        
        fetchRecipes()

    }
    
}
