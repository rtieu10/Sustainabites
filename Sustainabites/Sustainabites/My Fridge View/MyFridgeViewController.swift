//
//  FirstViewController.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 11/17/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//

import UIKit
import AVFoundation

//@VC: this view controller is the fridge view controller where users can select the ingredients they want to create a meal with
class MyFridgeViewController: UITableViewController, UISearchBarDelegate {
    
    //array of filtered data
    var filteredData: [Ingredient]!
    
    //storyboard connection to the search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    //a list of ingredients that the user chose from the list
    var selectedIngredients: [String]!=[]

    //set list of ingredients that users can choose from
    var ingredients = [Ingredient]()
    
    
    //@func: this function is called whenever the view is loaded initially, and we initilize the search bar delegate, the list of ingredients, and the arrays of selected / filtered ingredients 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(hideKeyboard))
        
        gestureRecognizer.cancelsTouchesInView = false
        
        view.addGestureRecognizer(gestureRecognizer)
        
        self.searchBar.delegate = self
        
        //initializing the populated list of ingredients
        self.ingredients = [Ingredient(ingredientName: "Apples"), Ingredient(ingredientName:"Beans"),Ingredient(ingredientName: "Beef"), Ingredient(ingredientName:"Butter"),Ingredient(ingredientName: "Broccoli"), Ingredient(ingredientName: "Carrots"), Ingredient(ingredientName:"Cheese"),Ingredient(ingredientName: "Chicken"),Ingredient(ingredientName: "Corn"), Ingredient(ingredientName: "Cucumber"), Ingredient(ingredientName: "Eggs"), Ingredient(ingredientName:"Flour"),Ingredient(ingredientName: "Garlic"),Ingredient(ingredientName: "Honey"),Ingredient(ingredientName: "Kale"),Ingredient(ingredientName: "Lemon"),Ingredient(ingredientName: "Lentils"), Ingredient(ingredientName: "Lettuce"), Ingredient(ingredientName: "Milk"),Ingredient(ingredientName: "Mushrooms"),Ingredient(ingredientName: "Oats"), Ingredient(ingredientName: "Onion"),Ingredient(ingredientName: "Oregano"),Ingredient(ingredientName: "Paprika"), Ingredient(ingredientName: "Pasta"),Ingredient(ingredientName: "Peas"), Ingredient(ingredientName: "Pepper"),Ingredient(ingredientName: "Potatoes"), Ingredient(ingredientName: "Rice"),Ingredient(ingredientName: "Salt"),Ingredient(ingredientName: "Shrimp"),Ingredient(ingredientName: "Spinach"), Ingredient(ingredientName: "Sugar"),Ingredient(ingredientName: "Tofu"), Ingredient(ingredientName: "Tomatoes"), Ingredient(ingredientName:"Tuna"), Ingredient(ingredientName: "Turkey")]
        
      
        //sets the filtered list of ingredients to the full list at first
        filteredData = ingredients
        //set the selected ingredients to empty each time
        selectedIngredients = []

        
    }
    
    
    //@func: this function closes the keyboard when the user clicks out of the keyboard
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer){
        view.endEditing(true) 
    }
    
    
    //@func: this function returns the number of items in the ingredient array
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return filteredData.count
    }
    
    
    //@func: this function adds checkmarks to the cells of the table, if the ingredient is in the selected ingredients list, if not it has no checkmark 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = filteredData[indexPath.row].name
        
        if selectedIngredients.contains((cell.textLabel?.text)!){
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        else{
            cell.accessoryType =  UITableViewCell.AccessoryType.none
        }
        return cell
        
    }
    
    //@func: this function adds / removes the ingredient that the user selected from the selectedIngredients list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath){
        
        let cell = tableView.cellForRow(at: indexPath)
        let name  = cell?.textLabel?.text
        
        //if user taps on the ingredient again, and it's already in the list, then remove it
        if selectedIngredients.contains(cell?.textLabel?.text ?? ""){
            selectedIngredients = selectedIngredients.filter{$0 != cell?.textLabel?.text}
        }
        
        //if the ingredient is not in the list yet, add it
        else{
            selectedIngredients.append((cell?.textLabel?.text)!)
        }
        
        tableView.reloadData()
        
        //printing selected ingredients in array for testing
        for x in selectedIngredients{
            print(x)
        }
        
        print("---------------")
            
    }
        
    //@func: this function is called each time the text changes in the search bar,the function filters the search results for users based on search
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText: String){
        filteredData = []

        //if search bar empty, all the ingredients pop up
        if searchText == "" {
            filteredData = ingredients
        }

        //if the search bar isnt empty, search and filter for ingredients matching the search term and add the ingredients to filteredData array
        else{
            for food in ingredients{
                if food.name.lowercased().contains(searchText.lowercased()){
                    filteredData.append(food)
                }
            }
        }
        
        //refreshes search results as user types, updates filteredData
        self.tableView.reloadData()
    }
    
    
    //@func: styling of the search bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    
    //@func: delegate for the search bar,and show what text is in the search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    

    //@func: this function sends the array of selected ingredients to the next view controller for the API call
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let vc = segue.destination as! RecipeViewController
        vc.ingredList  = selectedIngredients
    }
    
    
}

