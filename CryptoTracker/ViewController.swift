//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Fernando González González on 21/01/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        APICaller.shared.getAllCryptoData{
            
            result in
            
            switch result{
                
            case .success(let model):
                print("Success")
                print(model.count)
                
                
            case .failure(let error):
                print("Error")
                print(error.localizedDescription)
            
            }
        }
    }


}

