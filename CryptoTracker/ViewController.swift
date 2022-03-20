//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Fernando González González on 21/01/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tableCrypto: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    var arrCrypto = [Any]()
    var arrAssets = [Any]()
    var arrFilter = [Any]()
    
    private var arrViewModels = [CryptosViewModel]()
    
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
        
        if NetworkMonitor.shared.isConnected{
            print("Tienes internet")
            webService()
            configureTable()
            arrFilter = arrCrypto
            
        }else{
            print("No tienes internet ")
            internetConection()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Configurations
    private func configureTable(){
        title = "Crypto Tracker"
        tableCrypto.delegate = self
        tableCrypto.dataSource = self
        tableCrypto.register(itemTable.nib(), forCellReuseIdentifier: itemTable.identifier)
        
        //Configure searchBar
        searchBar.delegate = self
    }
    
    
    private func internetConection(){
        let message = UIAlertController(title: "Conexión a internet", message: "No tienes internet", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        message.addAction(btnOk)
        
        self.present(message, animated: true, completion: nil)
    }
    
    //MARK: - WebService
    private func webService(){
        
            APICaller.shared.getAllCryptoData{
                
                [weak self] (result) -> Void in
                
                switch result{
                    
                case .success(let model):
                    print("-----------------Success-----------------")
                    
                    //var arrData = [Any]()
                    
                    
                    self?.arrViewModels = model.compactMap({ model in
                        let volume = model.volume_1day_usd ?? 0
                        let price = model.price_usd ?? 0
                        let formatter = ViewController.numberFormatter
                        let priceString = formatter.string(from: NSNumber (value: price))
                        let valueString = formatter.string(from: NSNumber( value: volume))
                        
                        //Obtener los iconos del endpoint
                        let iconUrl = URL(string: APICaller.shared.arrIcons.filter({ icon in
                            icon.asset_id == model.asset_id
                        }).first?.url ?? "")
                        
                        return CryptosViewModel.init(name: model.name ?? "N/A",
                                                     symbol: model.asset_id ?? "N/A",
                                                     price: priceString ?? "N/A",
                                                     volume: valueString ?? "N/A",
                                                     iconUrl:iconUrl
                        )
                    })
                    
                    print(self!.arrViewModels)
                    
                    
                    DispatchQueue.main.async {
                        self!.recoveryInfo()
                    }
                    
                case .failure(let error):
                    print("-----------------Error-----------------")
                    print(error.localizedDescription)
                
                }
            }
        //getAllAssets()
    }
    
    //MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrFilter = []
        
        if searchText == ""{
            arrFilter = arrCrypto
            recoveryInfo()
        }else{
            print("Arreglo de Cryptos", arrFilter)
            
            for i in arrCrypto{
                print(i)
                let temp = i as! [Any]
                
                let nameCrypto = temp[0] as! String
                
                if nameCrypto.lowercased().contains(searchText.lowercased()){
                    print("Found Crypto")
                    arrFilter.append(i)
                    recoveryInfo()
                }else{
                    print("Not Found Crypto")
                }
                
            }
        }
    }
    /*
    private func getAllAssets(){
        
        APICaller.shared.getAllAssetsCrypto{
            [weak self] (result) in
            
            switch result{
            case .success(let model):
                print("Succes get Assets")
                //var cont = 0
                var arrData = [Any]()
                
                for i in model{
                    if let asset = i.asset_id{
                        arrData.append(asset)
                    }else{
                        arrData.append("N/A")
                    }
                    
                    if let url = i.url{
                        arrData.append(url)
                    }else{
                        arrData.append("N/A")
                    }
                    
                    self!.arrAssets.append(arrData)
                    arrData = [Any]()
                }
                
            case .failure(let err):
                print("Fail")
                print(err)
                
            }
        }
        
        
        
    }
     
     */
    
    private func recoveryInfo(){
        tableCrypto.reloadData()
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemTable.identifier, for: indexPath) as! itemTable
        
        //cell.configureCell(arrData: arrFilter[indexPath.row] as! [Any])
        cell.configureVM(with: arrViewModels[indexPath.row])
        
        return cell
    }
    
    
    
    func compareDatas(){
        print("\n\n\n\nInicio-------------------")
        print(arrAssets.count)
        
        var arrTemp = [String]()
        var count = 0
        var arrDataAsset = [Any]()
        
        for i in arrCrypto{
            let temp = i as! [Any]
            arrTemp.append("\(temp[0])")
        }
        
        print(arrTemp)
        
        
        for i in arrAssets{
            let tem = i as! [String]
            if count <= arrAssets.count - 1{
                let item = tem.filter{_ in tem[0].contains(arrTemp[count]) }
                arrDataAsset.append(item)
                count += 1
                print(arrDataAsset)
            }else{
                break
                
            }
            
        }
        
        print(arrDataAsset)
        print("Fin-------------------\n\n\n\n")
    }
    
    
    private func fillArr(arrTemp:[String]){
        
        var count = 0
        var arrDataAsset = [Any]()
        
        for j in arrAssets{
            let tem = j as! [Any]
            
            if count != arrTemp.count{
                
                print("Contador", count)
                if "\(tem[0])" ==  arrTemp[count]{
                    arrDataAsset.append(tem)
                    
                }
                count += 1
                
            }else if count >= arrTemp.count{
                print(count)
                print(arrTemp.count)
                print(arrDataAsset)
                print("Se llegó al limite")
                return
            }
            
            
        }
        print(arrDataAsset.count)
        print(arrDataAsset)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableCrypto.endEditing(true)
    }
    
}

