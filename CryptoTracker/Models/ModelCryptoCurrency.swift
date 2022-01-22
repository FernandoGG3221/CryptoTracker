//
//  ModelCryptoCurrency.swift
//  CryptoTracker
//
//  Created by Fernando González González on 21/01/22.
//

import Foundation

struct ModelCrypto: Codable{
    let asset_id: String?
    let name: String?
    let type_is_crypto:Int?
    let data_quote_start: String?
    let data_quote_end:String?
    let data_trade_start:String?
    let data_trade_end:String?
    let data_symbols_count:Int?
    let volume_1hrs_usd:Double?
    let volume_1day_usd:Double?
    let volume_1mth_usd:Double?
    let data_start:String?
    let data_end:String?
}
