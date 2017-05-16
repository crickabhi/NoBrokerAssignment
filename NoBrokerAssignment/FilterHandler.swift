//
//  FilterHandler.swift
//  NoBrokerAssignment
//
//  Created by Abhinav Mathur on 16/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import Foundation

class FilterHandler
{
    static var apartmentType    = ["1 RK" : "RK1", "1 BHK" : "BHK1", "2 BHK" : "BHK2", "3 BHK" : "BHK3", "4 BHK" : "BHK4", "4+ BHK" : "BHK4+"]
    static var propertyType     = ["Apartment" : "AP", "Independent House" : "IH", "Builder Floor" : "IF"]
    static var leaseType        = ["Full" : "FULLY_FURNISHED","Semi" : "SEMI_FURNISHED" ]
    static var filterCategories = ["Apartment Type","Property Type","Furnished"]
    
    static var selectedFilter       : Dictionary<String,Array<String>> = [:]
    
    static var typeFilters          : Array<String> = []
    static var buildingTypeFilters  : Array<String> = []
    static var furnishTypeFilters   : Array<String> = []
    
    static var shortlistedFlats     : Array<String> = []

}
