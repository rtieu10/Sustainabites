//
//  RecipeData+CoreDataProperties.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 12/4/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//
//

import Foundation
import CoreData


extension RecipeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeData> {
        return NSFetchRequest<RecipeData>(entityName: "RecipeData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var imageType: String?
    @NSManaged public var likes: Int64
    @NSManaged public var usedIngredientCount: Int64
    @NSManaged public var usedIngredients: [Ingredients]?
    @NSManaged public var missedIngredientCount: Int64
    @NSManaged public var missedIngredients: [Ingredients]?
    @NSManaged public var unusedIngredientCount: Int64
    @NSManaged public var unusedIngredients: [Ingredients]?

}

extension RecipeData : Identifiable {

}
