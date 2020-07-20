//
//  HouseViewModel.swift
//  DTT
//
//  Created by Nayer Jabri on 6/10/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//

import Foundation
import Moya
import UIKit

class HousesViewModel :NSObject{
    
    var reloadList = {() -> () in }
    var filterHouses = [House]()
    let houseProvider = MoyaProvider<HouseService>()
    
    var onErrorHandling : ((ErrorResult?) -> Void)?
     ///Array of List Model class
       var HousesArray : [House] = []{
           ///Reload data when data set
           didSet{
               reloadList()
           }
       }
    
    //get json data
    func requestData(completion: @escaping ((_ data: [House]) -> Void)) {
       self.houseProvider.request(.readHouses) { (result) in
           switch result {
           case .success(let response):
               let houses = try!     JSONDecoder().decode([House].self  , from: response.data)
               self.HousesArray = houses
                completion(houses)
           case .failure(let error):
               print(error)
           }
       }
    }
}




