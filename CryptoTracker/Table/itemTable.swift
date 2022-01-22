//
//  itemTable.swift
//  CryptoTracker
//
//  Created by Fernando González González on 21/01/22.
//

import UIKit

class itemTable: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblNameCryp: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    
    //MARK: - Elements Static
    static let identifier = "idCellCrypto"
    
    static func nib() -> UINib{
        return UINib(nibName: "itemTable", bundle: nil)
    }

    //MARK: - Function from class
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Configuration Cell
    
    func configureCell(arrData:[Any]){
        print(arrData)
        configureLabels()
        lblNameCryp.text = "\(arrData[0])"
        lblVolume.text = "\(arrData[2])"
        lblPrice.text = "\(arrData[3])"
    }
    
    private func configureLabels(){
        lblNameCryp.textColor = .black
        lblPrice.textColor = .green
        lblVolume.textColor = .lightGray
    }
    
}
