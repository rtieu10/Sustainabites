//
//  RecipeData+CoreDataProperties.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 12/9/20.
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
    @NSManaged public var image: String?
    @NSManaged public var title: String?

}

extension RecipeData : Identifiable {

}
