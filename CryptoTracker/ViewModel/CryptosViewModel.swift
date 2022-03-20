//
//  CryptosViewModel.swift
//  CryptoTracker
//
//  Created by Fernando González González on 19/03/22.
//

import Foundation

 class CryptosViewModel{
    let name: String
    let symbol:String
    let price:String
    let volume:String
    let iconUrl:URL?
    var iconData:Data?
     
     init(
        name:String,
        symbol:String,
        price:String,
        volume:String,
        iconUrl:URL?
     ){
         self.name = name
         self.symbol = symbol
         self.price = price
         self.volume = volume
         self.iconUrl = iconUrl
     }
}
