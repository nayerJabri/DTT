//
//  Location.swift
//  DTT
//
//  Created by Nayer Jabri on 6/24/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {

    static let shared = Location()
    var userLocation: CLLocation

    override init() {
        userLocation = CLLocation()
    }

    

    
}
