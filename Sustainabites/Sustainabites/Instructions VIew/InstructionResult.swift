//
//  InstructionsResult.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 12/28/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//

import Foundation
import CoreData

//@class: this class corresponds to the result of the API call with the nam and steps array 
public class InstructionResult: NSObject, Codable {
    var name: String? = ""
    var steps: [Steps]?
}

//@class: this class contains the properties that correspond to the steps array in the API call for instructions
class Steps: Codable{
    var equip: [EquipIngred]?
    var ingredients: [EquipIngred]?
    var length: TempLen?
    var number: Int? = 0
    var step: String? = ""
}

//@class: this class outlines the properties of equipment and ingredients from the API call
class EquipIngred: Codable{
    var id: Int? = 0
    var image: String? = ""
    var name: String? = ""
    var temperature: TempLen?
}

//@class: this class outlines the properties of temperature and length from the API call
class TempLen: Codable{
    var number: Double? = 0.0
    var unit: String? = ""
}

