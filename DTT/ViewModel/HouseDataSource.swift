//
//  HouseDataSource.swift
//  DTT
//
//  Created by Nayer Jabri on 6/10/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//

import Foundation
import UIKit

class GenericDataSource<T> : NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}

class HouseDataSource : GenericDataSource<House>, UITableViewDataSource {
    
    var selectedHouse: House?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell", for: indexPath) as! HouseCell
        
        let house = self.data.value[indexPath.row]
        cell.house = house
        return cell
    }
    
    
    
 

        
}
