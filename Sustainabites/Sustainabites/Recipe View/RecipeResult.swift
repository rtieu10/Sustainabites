//
//  RecipeResult.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 11/27/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//

import Foundation
import CoreData

//@class: this class represents the object that is returned from an API call
public class RecipeResult: NSObject, Codable{
    
    var id: Int? = 0
    var title: String? = ""
    var image: String? = ""
    var imageType: String? =  ""
    var likes: Int? =  0
    var usedIngredientCount: Int? = 0
    var usedIngredients:[Ingredients]?
    var missedIngredientCount:Int? = 0
    var missedIngredients:[Ingredients]?
    var unusedIngredientCount: Int? = 0
    var unusedIngredients:[Ingredients]?
    
}


//@class: this class represents the list of missed/unused ingredients that are returned in the API call
class Ingredients: Codable{
    
    var aisle: String? = ""
    var amount: Double? =  0.0
    var id: Int? = 0
    var image: String? = ""
    var meta: [String]?
    var name: String? = ""
    var original: String? = ""
    var originalName: String? = ""
    var unit: String? = ""
    var unitLong: String? = ""
    var unitShort: String? = ""
    
}


