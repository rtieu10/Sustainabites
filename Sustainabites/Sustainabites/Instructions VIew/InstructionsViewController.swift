//
//  InstructionsViewController.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 12/28/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//

import Foundation
import UIKit

//@VC: this view controller displays the instructions obtained from the API call outline steps on preparing meals to users, the instructions are presented in a table view
class InstructionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var recipe_id = 0
    
    //this array is storing the data from the API call 
    var instructionResults = [InstructionResult]() 
    
    //an array of instructions on how to cook the food obtained from the API call
    var steps:[String]! = []
    
    @IBOutlet weak var tableView: UITableView!
    
    //@func: function called when view is initially loaded, and we initiate the API call, and store the data into the steps array, and use a dispatch to retrieve the data from the API call before proceeding
    override func viewDidLoad(){
        super.viewDidLoad()
        steps = []
        
        let dispatch = DispatchGroup()
        dispatch.enter()
        
        fetchData{ (instructionresults) in
            for instruction in instructionresults{
                var count = 1
                for x in instruction.steps!{
                    self.steps.append(String(count) + ". " + x.step!)
                    count = count + 1
                }
            }
            
            dispatch.leave()

        }
        
        //notify the main thread because it needs to be completed first, because UI updates need to be completed on main thread
        dispatch.notify(queue: .main){
            self.tableView.reloadData()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    //@func: this function generates the url for the API call for recipe instructions
    func instructionsURL(id: Int) -> URL{
        var selected_id = String(recipe_id) //setting the id to a string
        
        let APIKEY = Constants.SpoonacularApiKey
        
        let urlString = "https://api.spoonacular.com/recipes/\(selected_id)/analyzedInstructions?apiKey=\(APIKEY)"
        
        let url = URL(string:urlString)
        
        return url!
    }
    
    //@func: this function performs the API call, with the url we created from the helper function, and saves the data from the call into postsData
    func fetchData(completionHandler: @escaping ([InstructionResult]) -> Void){
        let url = instructionsURL(id: recipe_id)

        let session = URLSession.shared.dataTask(with: url){
            (data, response, error) in

            guard let data = data else{ return }

            do{
                //@postsData: the array of RecipeResult objects received from API call
                let postsData = try JSONDecoder().decode([InstructionResult].self, from:data)

                completionHandler(postsData)
            }
            catch{
                let error = error
                print(error.localizedDescription)
            }
            }.resume()

    }
    
    //@func: this function returns the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if steps.count ==  0{
            return 0
        }
        return steps.count
    }

    //@func: this function populates the table with steps that have been retrieved from the API call, and makes the text wrap around in the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: "instructionsCell", for:indexPath)

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.text = steps[indexPath.row]

        return cell

    }
    
    //@func: animates the cells for when the user deselects the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
