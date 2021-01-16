//
//  RecipeTableViewController.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 11/18/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController{
    
    var recipeResults = [RecipeResult]()  //recipe results will be a list of recipe result objects
    
   override func viewDidLoad() {
          super.viewDidLoad()
          let cellNib = UINib(nibName: "RecipeResultCell", bundle:nil)
          tableView.register(cellNib, forCellReuseIdentifier:"RecipeResultCell")
          
          for i in 0...2{
              let recipeResult = RecipeResult()
              recipeResult.mealName = String(format: "Lasagna", i)
              recipeResult.amountOfTime = String(format: "45 minutes")
              recipeResults.append(recipeResult)
          }
          
          tableView.reloadData()
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeResultCell", for: indexPath) as! RecipeResultCell
          
          //each recipe result object will be set equal to a unique recipe in the recipe Results array
          //we change the label name, to be the recipe result objects name and time attribute
          let recipeResult = recipeResults[indexPath.row]
          cell.recipeNameLabel.text = recipeResult.mealName
          cell.durationLabel.text = recipeResult.amountOfTime
          
          return cell
      }
}

