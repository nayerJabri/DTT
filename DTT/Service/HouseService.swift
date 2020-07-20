//
//  HouseService.swift
//  DTT
//
//  Created by Nayer Jabri on 6/10/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//
import Foundation
import Moya

enum HouseService {
    case readHouses
}

extension HouseService: TargetType {
    var baseURL: URL {
        return URL(string: "https://intern.docker-dev.d-tt.nl/api/house")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        //no params needed
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Access-Key": "98bww4ezuzfePCYFxJEWyszbUXc7dxRx"]
    }
    
    
}
