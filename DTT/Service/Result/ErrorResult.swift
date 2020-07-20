//
//  ErrorResult.swift
//  DTT
//
//  Created by Nayer Jabri on 6/10/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}
