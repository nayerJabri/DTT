//
//  NSAttributedStrinf.swift
//  DTT
//
//  Created by Nayer Jabri on 6/22/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
           self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        return false
    }
}
