//
//  APICaller.swift
//  CryptoTracker
//
//  Created by Fernando González González on 21/01/22.
//

import Foundation

final class APICaller{
    
    static let shared = APICaller()
    
    private struct ApiKey{
        static let apiKey = "B02E72E4-14A0-4319-B725-1DFDDE9E451F"
    }
    
    private struct Constants {
        static let assetsEndPoint = "https://rest-sandbox.coinapi.io/v1/assets"
        static let apiKey = ApiKey.apiKey
    }
    
    private struct ConstantsAssets{
        static let assetsEndPoint = "https://rest.coinapi.io/v1/assets/icons/55?apikey="
        static let apiKey = ApiKey.apiKey
    }
    
    private init (){
        
    }
    
    public func getAllCryptoData(completion:@escaping (Result<[ModelCrypto], Error>) -> Void){
        guard let url = URL(string: Constants.assetsEndPoint + "?apikey=" + Constants.apiKey) else{
            return
        }
        
        print(url)
        
        URLSession.shared.dataTask(with: url){
            (data, response, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            do{
                
                let coder = try JSONDecoder().decode([ModelCrypto].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(coder))
                }
                
                //print(coder)
                
            }catch{
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    public func getAllAssetsCrypto(completition: @escaping (Result <[ModelAssetsCrypto], Error>) -> Void){
        
        guard let url = URL(string: ConstantsAssets.assetsEndPoint + ConstantsAssets.apiKey) else{
            return
        }
        
        print(url)
        
        URLSession.shared.dataTask(with: url){
            (data, response, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let coder = try JSONDecoder().decode([ModelAssetsCrypto].self, from: data)
                
                DispatchQueue.main.async {
                    completition(.success(coder))
                }
                
            }catch{
                completition(.failure(error))
                //print(err.localizedDescription)
            }
            
        }.resume()
        
    }
    
}
