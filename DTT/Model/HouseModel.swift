//
//  HouseModel.swift
//  DTT
//
//  Created by Nayer Jabri on 6/10/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//

import Foundation


struct House: Decodable {
    let id : Int
    let image : String
    let price : Int
    let bedrooms : Int
    let bathrooms : Int
    let size : Int
    let description : String
    let zip : String
    let city : String
    let latitude : Double
    let longitude : Double
    let createdDate : String
    
    //the distance between user location and the house
    var distance : String? = "Unknown"
}


