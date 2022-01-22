//
//  Extensions.swift
//  CryptoTracker
//
//  Created by Fernando González González on 22/01/22.
//

import Foundation
import UIKit

func numberFormatt(){
    
    let numberFormatter:NumberFormatter = {
        
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        return formatter
    }()
    
}
