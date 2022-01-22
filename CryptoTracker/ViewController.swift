//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Fernando González González on 21/01/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var tableCrypto: UITableView!
    
    //MARK: - Properties
    var arrCrypto = [Any]()
    static let numberFormatter:NumberFormatter = {
        
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        return formatter
    }()
    
    //MARK: - Cyclelife Screen
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webService()
        configureTable()
    }
    
    //MARK: - Configurations
    func configureTable(){
        title = "Crypto Tracker"
        tableCrypto.delegate = self
        tableCrypto.dataSource = self
        tableCrypto.register(itemTable.nib(), forCellReuseIdentifier: itemTable.identifier)
    }
    
    //MARK: - WebService
    func webService(){
        
            APICaller.shared.getAllCryptoData{
                
                [weak self] (result) -> Void in
                
                switch result{
                    
                case .success(let model):
                    print("Success")
                    
                    var arrData = [Any]()
                
                    for i in model{
                        
                        if let name = i.name{
                            arrData.append(name)
                        }else{
                            arrData.append("N/A")
                        }
                        
                        if let asset = i.asset_id{
                            arrData.append(asset)
                        }else{
                            arrData.append("N/A")
                        }
                        
                        if let dayU = i.volume_1day_usd{
                            arrData.append(dayU)
                        }else{
                            arrData.append("0")
                        }
                        
                        if let price = i.price_usd{
                            let formatter = ViewController.numberFormatter
                            let priceString = formatter.string(from: NSNumber(floatLiteral: Double(price)))
                            
                            arrData.append(priceString!)
                        }else{
                            arrData.append("0")
                        }
                        
                        self!.arrCrypto.append(arrData)
                        arrData = [Any]()
                    }
                    
                    print("Recargando datos")
                    //self!.recoveryInfo()
                    DispatchQueue.main.async {
                        self!.recoveryInfo()
                    }
                    
                case .failure(let error):
                    print("Error")
                    print(error.localizedDescription)
                
                }
            }
        
    }
    
    func recoveryInfo(){
        tableCrypto.reloadData()
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arrCrypto.count)
        return arrCrypto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemTable.identifier, for: indexPath) as! itemTable
        
        cell.configureCell(arrData: arrCrypto[indexPath.row] as! [Any])
        
        return cell
    }
}

