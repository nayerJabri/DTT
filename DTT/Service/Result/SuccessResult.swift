//
//  SuccessResult.swift
//  DTT
//
//  Created by Nayer Jabri on 6/11/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//

import Foundation

enum SuccessResult: String {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}
