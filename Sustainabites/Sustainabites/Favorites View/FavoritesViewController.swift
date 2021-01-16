//
//  SecondViewController.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 11/17/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//

import UIKit
import CoreData

//@VC: the favorites table view controller displays recipes saved by the user in a table view format
class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //outlet to the table view in the view controller
    @IBOutlet weak var tableView: UITableView!
    
    //@struct: a struct to reference the customized cell names 
    struct TableView{
        struct CellIdentifiers{
            static let FavoritesItemCell = "FavoritesItemCell"
        }
    }
    
    //array of items saved in CoreData to display
    var FavoritesList = [RecipeData]()
    
    var favorite_id = 0
    
    //reference to managed object context in order to save and retrieve data, we can access the persistent container through this
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    
    
    //@func: this function is called whenever the view is loaded for the first time, the custom cells are registered to be used, and we fetch the ingredients that are stored in CoreData 
    override func viewDidLoad(){
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.FavoritesItemCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.FavoritesItemCell)
        
        self.fetchRecipes()
    }
    
    
    //@func: this function is called everytime the view appears, and it consistently fetches data from CoreData
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchRecipes()
    }
    
    
    //@func: this function fetches the data that is currently stored in CoreData and saves it into the FavoritesList array
    func fetchRecipes(){
        do{
            //passing in a request to grab RecipeData objects from CoreData
            self.FavoritesList = try context.fetch(RecipeData.fetchRequest())
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        catch{
            print("Could not load recipes")
        }
    }
    
    //@func: this function returns the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FavoritesList.count == 0{
            return 0
        }
        return FavoritesList.count
    }
    
    //@func: this function populates the table with custom FavoritesItemCells, by updating each cell with the appropriate recipe name and image that is stored in CoreData 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.FavoritesItemCell, for: indexPath) as! FavoritesItemCell
        
        let favoriteRecipe = self.FavoritesList[indexPath.row] //gives us the RecipeData object
        
        cell.updateUI(for:favoriteRecipe)
        
        return cell
    }
    
    
    //@func: this function provides a deselection animation based on the row the user taps, it also passes the id of the selected meal to the Instructions VC for the next API call
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        favorite_id = Int(FavoritesList[indexPath.row].id)
        
        let Storyboard = UIStoryboard(name:"Main", bundle: nil)
        
        //set the destination of the meal id to the instructions VC, and pass the id to the next VC
        let vc = Storyboard.instantiateViewController(withIdentifier: "InstructionsViewController") as! InstructionsViewController
        vc.recipe_id = favorite_id
        
        //perform segue to the instructions VC 
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //@func: this function tells the delegate if the row in the table is about to be selected
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      if FavoritesList.count == 0 {
        return nil
      } else {
        return indexPath
      }
    }
    
    
    //@func: this function allows users to delete items from the tableView in the FavoritesViewController, it deletes the item from CoreData, and from the local FavoritesList array 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete
           {
               guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

                context.delete(FavoritesList[indexPath.row])

               do {
                   try context.save()
                
                    FavoritesList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
               }catch let err as NSError {
                   print("Could not delete item", err)
               }
           }
        
    }
    
    //@func: this function animates the  table cells the first time the screen loads,  and animates as the user scrolls through their favorites 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75, animations: {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        })
    }
    
}


